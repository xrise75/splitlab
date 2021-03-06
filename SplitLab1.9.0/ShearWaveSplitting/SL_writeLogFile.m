function SL_writeLogFile(option, config, thiseq)
% OPTION='LOG'  writes the constant logfile for every attempted splitting measurement
% OPTION='DATA' writes the datafile for accepted measurements
% see ./saveresults

    switch upper(option)
        case 'LOG'
            fname = fullfile(config.savedir,['all_results_',config.project(1:end-4),'.log']);
        case 'DATA'
            if strcmp(thiseq.Qstr(5:8),'Null')
                fname = fullfile(config.savedir,['splitresultsNULL_' config.project(1:end-4) '.dat' ]);
            else
                fname = fullfile(config.savedir,['splitresults_'     config.project(1:end-4) '.dat' ]);
            end
    end
            
    if ~exist(fname, 'file')
        h = helpdlg ({'No logfile:', fname,' ', 'The file is created and result stored, but check output directory if that is what you wanted.'});
        waitfor(h);
    end
    
    % open file and get first line
    fid = fopen(fname,'r');
    if fid ~= -1
        firstLine = fgetl( fid );
        fclose( fid );
    else
        firstLine = -1;
    end

    % close file and open again in 'append' mode, go to EOF
    fid   = fopen(fname,'a');

    % header line
    header = {...
       sprintf( '%20s','EQ_Date_Time'          )   ...
       sprintf( '%11s','Station'               )   ...
       sprintf( '%15s','sLat'                  )   ...
       sprintf( '%15s','sLon'                  )   ...
       sprintf( '%15s','sEle'                  )   ...
       sprintf( '%15s','eLat'                  )   ...
       sprintf( '%15s','eLon'                  )   ...
       sprintf( '%15s','eDep'                  )   ...
       sprintf( '%15s','eDis'                  )   ...
       sprintf( '%14s','eMw'                   )   ...
        ...
       sprintf( '%15s', 'geoinc'               )   ...                                              
       sprintf( '%15s', 'geobazi'              )   ...
       sprintf( '%15s', 'bazi'                 )   ...
       sprintf( '%15s', 'geodis3D'             )   ...
       sprintf( '%15s', 'SplitPhase'           )   ...
       sprintf( '%15s', 'selectedpol'          )   ...
       sprintf( '%15s', 'selectedinc'          )   ...
       sprintf( '%15s', 'filter(1)'            )   ...
       sprintf( '%15s', 'filter(2)'            )   ...
        ...
       sprintf( '%15s', 'phiRC(1)'             )   ...
       sprintf( '%15s', 'phiRC(2)'             )   ...
       sprintf( '%15s', 'dtRC(1)'              )   ...
       sprintf( '%15s', 'dtRC(2)'              )   ...
       sprintf( '%15s', 'phiEV(1)'             )   ...
       sprintf( '%15s', 'phiEV(2)'             )   ...
       sprintf( '%15s', 'dtEV(1)'              )   ...
       sprintf( '%15s', 'dtEV(2)'              )   ...
       sprintf( '%15s', 'RC_strike'            )   ...
       sprintf( '%15s', 'EV_strike'            )   ...
        ...
       sprintf( '%20s', 'RC_dips'              )   ...
       sprintf( '%20s', 'EV_dips'              )   ...
       sprintf( '%20s', 'init_pol'             )   ...
       sprintf( '%18s', 'SNR'                  )   ...
       sprintf( '%12s', 'Q_auto'               )   ...
       sprintf( '%12s', 'Q_manu'               )   ...
       sprintf( '%21s', 'dom_freq_EV_Q-comp'   )   ...
        } ; 

    % actual data
    fields = {...
       strrep( sprintf( '%19s', datestr(thiseq.date(1:6), 31)), ' ', '_')   ...    1    Date
       sprintf( '%11s', config.stnname                   )   ...    2    StationName
       sprintf( '%15.4f', config.slat                    )   ...    3
       sprintf( '%15.4f', config.slong                   )   ...    4
       sprintf( '%15.2f', config.selev                   )   ...    5
       sprintf( '%15.4f', thiseq.lat                     )   ...    6
       sprintf( '%15.4f', thiseq.long                    )   ...    7
       sprintf( '%15.2f', thiseq.depth                   )   ...    8
       sprintf( '%15.4f', thiseq.dis                     )   ...    9
       sprintf( '%14.2f', thiseq.Mw                      )   ...   10
        ...            
       sprintf( '%15.4f', thiseq.geoinc                  )   ...   12                                              
       sprintf( '%15.4f', thiseq.geobazi                 )   ...   13
       sprintf( '%15.4f', thiseq.bazi                    )   ...   14
       sprintf( '%15.4f', thiseq.geodis3D                )   ...   15
       sprintf( '%15s',   thiseq.SplitPhase              )   ...   16
       sprintf( '%15.4f', thiseq.selectedpol             )   ...   17
       sprintf( '%15.4f', thiseq.selectedinc             )   ...   18
       sprintf( '%15.4f', thiseq.filter(1)               )   ...   19            
       sprintf( '%15.4f', thiseq.filter(2)               )   ...   20
        ...
       sprintf( '%15.6f', thiseq.tmpresult.phiRC(1)      )   ...   21
       sprintf( '%15.6f', thiseq.tmpresult.phiRC(2)      )   ...   22
       sprintf( '%15.6f', thiseq.tmpresult.dtRC(1)       )   ...   23
       sprintf( '%15.6f', thiseq.tmpresult.dtRC(2)       )   ...   24
       sprintf( '%15.6f', thiseq.tmpresult.phiEV(1)      )   ...   25
       sprintf( '%15.6f', thiseq.tmpresult.phiEV(2)      )   ...   26 
       sprintf( '%15.6f', thiseq.tmpresult.dtEV(1)       )   ...   27
       sprintf( '%15.6f', thiseq.tmpresult.dtEV(2)       )   ...   28
       sprintf( '%15.6f', thiseq.tmpresult.strikes(1)    )   ...   29 RC strike
       sprintf( '%15.6f', thiseq.tmpresult.strikes(3)    )   ...   30 EV strike
        ...
       sprintf( '%20.6f', thiseq.tmpresult.dips(1)       )   ...   31
       sprintf( '%20.6f', thiseq.tmpresult.dips(3)       )   ...   32
       sprintf( '%20.6f', thiseq.tmpresult.inipol        )   ...   33
       sprintf( '%18.6f', thiseq.tmpresult.SNR(2)        )   ...   34
       sprintf( '%12.6f', thiseq.Q                       )   ...   35 Automatic quality
       sprintf( '%12s',   deblank(thiseq.Qstr)           )   ...   36 Manual quality
       sprintf( '%21.10f',thiseq.tmpresult.domfreq       )   ...   37 Dominant frequency on EV-corrected Q-component
        } ;

    % if there no first line could be found before (e.g. complete new
    % file), then write the 'header' as first line
    if firstLine == -1      
        fprintf(fid, '%s', header{1:end});
        fprintf(fid, '\n');
    end
    fprintf(fid, '%s', fields{1:end});
    fprintf(fid, '\n');
    fclose(fid);        
        