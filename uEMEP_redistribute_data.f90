!uEMEP_redistribute_local_source
!Same routine for all sources
    
    subroutine uEMEP_redistribute_local_source(source_index)
    
    use uEMEP_definitions
    
    implicit none

    integer i,j,k
    integer source_index
    character(256) temp_name
    logical exists
    integer ii,jj,tt
    integer i_temp,j_temp
    integer integral_counter
    real sum_integral
    integer i_start,i_end,j_start,j_end,t_start,t_end
    integer subsource_index,emep_subsource
    integer i_cross,j_cross
    integer i_cross_integral,j_cross_integral
    real x_pos,y_pos
    real xpos_limit,ypos_limit
    real xpos_area_min,xpos_area_max,ypos_area_min,ypos_area_max
    real xpos_subgrid,ypos_subgrid
    real xpos_integral_subgrid,ypos_integral_subgrid
    
    
    !allocate (sum_integral(subgrid_dim(1),subgrid_dim(2))) !Can just be a scalar
    !allocate (scaling_factor_traffic_subgrid(subgrid_dim(1),subgrid_dim(2))) !Can just be a scalar
    !allocate (traffic_redistributed_local_subgrid(subgrid_dim(1),subgrid_dim(2))) !Can just be a scalar
    
    if (local_subgrid_method_flag.ne.1) return
    
 
    write(unit_logfile,'(A)') ''
    write(unit_logfile,'(A)') '================================================================'
	write(unit_logfile,'(A)') 'Redistribute local source using EMEP concentrations (uEMEP_redistribute_local_source)'
	write(unit_logfile,'(A)') '================================================================'

    !No subsources for the emep related arrays
    emep_subsource=1

    !If EMEP gridded to subgrid files already exist then read them in and leave the subroutine
    do subsource_index=1,n_subsource(source_index)
    temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//trim(subsource_str(subsource_index))//'_'//trim(file_tag)//'.asc'
    if (read_existing_grid_data(subgrid_local_file_index(source_index))) then
        inquire(file=temp_name,exist=exists)
        if (.not.exists) then
            write(unit_logfile,*)'ERROR: '//trim(temp_name)//' does not exist.'
            return
        endif
        call read_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,local_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
        return
    endif
    enddo

    write(unit_logfile,'(2A)')'Calculating the scaling factor and local contribution at each subgrid for ',trim(source_file_str(source_index))

    xpos_limit=dgrid_nc(lon_nc_index)/2.*EMEP_grid_interpolation_size
    ypos_limit=dgrid_nc(lat_nc_index)/2.*EMEP_grid_interpolation_size

    !Set the start and end times of the loop
    t_start=1
    t_end=subgrid_dim(t_dim_index)

    do subsource_index=1,n_subsource(source_index)
    
    do tt=t_start,t_end
        
    !Calculate the mean concentration of the integral values for each subgrid point
    do j=1,subgrid_dim(y_dim_index)
    do i=1,subgrid_dim(x_dim_index)
        
        if (use_subgrid(i,j,source_index)) then

            sum_integral=0.
            integral_counter=0
        
            i_cross_integral=crossreference_target_to_integral_subgrid(i,j,x_dim_index)
            j_cross_integral=crossreference_target_to_integral_subgrid(i,j,y_dim_index)

            xpos_integral_subgrid=xproj_subgrid(i,j)
            ypos_integral_subgrid=yproj_subgrid(i,j)


            !Use the wind direction to move the target area downwind
            if (use_downwind_position_flag.and.hourly_calculations) then
    
                !Add one to make sure the integral region is large enough
                !x_pos=max(-1.,min(1.,meteo_subgrid(i_cross_integral,j_cross_integral,tt,cos_subgrid_index)*sqrt(2.)))
                !y_pos=max(-1.,min(1.,meteo_subgrid(i_cross_integral,j_cross_integral,tt,sin_subgrid_index)*sqrt(2.)))                    
                
                !i_end=min(ceiling(i_cross_integral+(1.-x_pos)*integral_subgrid_loop_index(x_dim_index)),integral_subgrid_dim(x_dim_index)) 
                !i_start=max(floor(i_cross_integral-(1.+x_pos)*integral_subgrid_loop_index(x_dim_index)),1)
                !j_end=min(ceiling(j_cross_integral+(1.-y_pos)*integral_subgrid_loop_index(y_dim_index)),integral_subgrid_dim(y_dim_index))
                !j_start=max(floor(j_cross_integral-(1.+y_pos)*integral_subgrid_loop_index(y_dim_index)),1)
                
                !xpos_area_max=xpos_integral_subgrid+(1.-x_pos)*xpos_limit
                !xpos_area_min=xpos_integral_subgrid-(1.+x_pos)*xpos_limit
                !ypos_area_max=ypos_integral_subgrid+(1.-y_pos)*ypos_limit
                !ypos_area_min=ypos_integral_subgrid-(1.+y_pos)*ypos_limit
 
                !Use the same area as for non upwind
                i_start=max(1,i_cross_integral-integral_subgrid_loop_index(x_dim_index))
                i_end=min(integral_subgrid_dim(x_dim_index),i_cross_integral+integral_subgrid_loop_index(x_dim_index))
                j_start=max(1,j_cross_integral-integral_subgrid_loop_index(y_dim_index))
                j_end=min(integral_subgrid_dim(y_dim_index),j_cross_integral+integral_subgrid_loop_index(y_dim_index))

                xpos_area_max=xpos_integral_subgrid+xpos_limit
                xpos_area_min=xpos_integral_subgrid-xpos_limit
                ypos_area_max=ypos_integral_subgrid+ypos_limit
                ypos_area_min=ypos_integral_subgrid-ypos_limit

            else
                !Find the cross reference to the integral grid from the target grid
                !i_cross=crossreference_target_to_integral_subgrid(i,j,x_dim_index)
                !j_cross=crossreference_target_to_integral_subgrid(i,j,y_dim_index)
       
                i_start=max(1,i_cross_integral-integral_subgrid_loop_index(x_dim_index))
                i_end=min(integral_subgrid_dim(x_dim_index),i_cross_integral+integral_subgrid_loop_index(x_dim_index))
                j_start=max(1,j_cross_integral-integral_subgrid_loop_index(y_dim_index))
                j_end=min(integral_subgrid_dim(y_dim_index),j_cross_integral+integral_subgrid_loop_index(y_dim_index))
 
                xpos_area_max=xpos_integral_subgrid+xpos_limit
                xpos_area_min=xpos_integral_subgrid-xpos_limit
                ypos_area_max=ypos_integral_subgrid+ypos_limit
                ypos_area_min=ypos_integral_subgrid-ypos_limit
                
            endif

            !write(*,*) i_start-i_cross_integral,i_end-i_cross_integral,j_start-j_cross_integral,j_end-j_cross_integral
                !Calculate the average grid concentration at each integral subgrid based on proxy integral
                do jj=j_start,j_end
                do ii=i_start,i_end
                    
                    xpos_integral_subgrid=xproj_integral_subgrid(ii,jj)
                    ypos_integral_subgrid=yproj_integral_subgrid(ii,jj)
                    
                    if (xpos_integral_subgrid.ge.xpos_area_min.and.xpos_integral_subgrid.le.xpos_area_max &
                        .and.ypos_integral_subgrid.ge.ypos_area_min.and.ypos_integral_subgrid.le.ypos_area_max) then                  

                        sum_integral=sum_integral+integral_subgrid(ii,jj,tt,source_index,subsource_index)
                        integral_counter=integral_counter+1
                        !write(*,*) i,j,ii-i_cross_integral,jj-j_cross_integral
                    endif  
                enddo
                enddo

            !Calculate scaling factor
            if (sum_integral.ne.0) then
                subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index)=subgrid(i,j,tt,proxy_subgrid_index,source_index,subsource_index)/sum_integral*integral_counter
            else
                subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index)=0.
            endif
            !write(*,*) subgrid(i,j,source_index,scaling_factor_subgrid_index),subgrid(i,j,source_index,proxy_subgrid_index)
            if (isnan(subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index))) write(*,*) i,j,sum_integral,integral_counter
            if (isnan(subgrid(i,j,tt,emep_local_subgrid_index,source_index,subsource_index))) write(*,*) 'L',i,j,sum_integral,integral_counter
            !if (subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index).lt.0) write(*,'(a,i,i,i,f,f,f)') 'LT0',i,j,integral_counter,sum_integral/integral_counter,subgrid(i,j,tt,proxy_subgrid_index,source_index,subsource_index),subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index)
            !if (subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index).gt.10) write(*,'(a,i,i,i,f,f,f,f)') 'GT10',i,j,integral_counter,sum_integral,integral_subgrid(i_cross_integral,j_cross_integral,tt,source_index,subsource_index),subgrid(i,j,tt,proxy_subgrid_index,source_index,subsource_index),subgrid(i,j,tt,scaling_factor_subgrid_index,source_index,subsource_index)
        
        endif
        
    enddo
        !write(*,*) 'Redistribution',j,' of ',subgrid_dim(2)
    enddo
        write(*,*) 'Redistribution time ',tt,' of ',subgrid_dim(t_dim_index)
    enddo

    !Calculate redistributed subgrid source concentrations
    subgrid(:,:,:,local_subgrid_index,source_index,subsource_index)=subgrid(:,:,:,scaling_factor_subgrid_index,source_index,subsource_index)*subgrid(:,:,:,emep_local_subgrid_index,source_index,emep_subsource)
   
     
    !Save files
    if (save_intermediate_files) then
    if (.not.read_existing_grid_data(subgrid_local_file_index(source_index))) then
        !do subsource_index=1,n_subsource(source_index)
        temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//trim(subsource_str(subsource_index))//'_'//trim(file_tag)//'.asc'
        write(unit_logfile,'(a)')'Writing to: '//trim(temp_name)
        call write_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,local_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
        temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//trim(subsource_str(subsource_index))//'_sf_'//trim(file_tag)//'.asc'
        write(unit_logfile,'(a)')'Writing to: '//trim(temp_name)
        call write_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,scaling_factor_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
        !enddo
    endif
    endif
    
    enddo !Subsource loop
    
    end subroutine uEMEP_redistribute_local_source
    

!uEMEP_disperse_local_source
!Same routine for all sources
    !This routine uses the emission factors and meteorology to calculate the local concentrations
    !This is instead of redistributing using proxy data
    !Gives the same output as the uEMEP_redistribute_local_source
    
    subroutine uEMEP_disperse_local_source(source_index)
    
    use uEMEP_definitions
    
    implicit none

    integer i,j,k
    integer source_index
    character(256) temp_name
    logical exists
    integer ii,jj,tt
    integer i_temp,j_temp
    integer integral_counter
    real sum_integral
    integer i_start,i_end,j_start,j_end,t_start,t_end
    integer subsource_index
    integer i_cross,j_cross
    real u_temp
    real z0_temp,h_temp
    
    !allocate (sum_integral(subgrid_dim(1),subgrid_dim(2))) !Can just be a scalar
    !allocate (scaling_factor_traffic_subgrid(subgrid_dim(1),subgrid_dim(2))) !Can just be a scalar
    !allocate (traffic_redistributed_local_subgrid(subgrid_dim(1),subgrid_dim(2))) !Can just be a scalar

    if (local_subgrid_method_flag.ne.2.and.local_subgrid_method_flag.ne.3.and.local_subgrid_method_flag.ne.4) return
    
    write(unit_logfile,'(A)') ''
    write(unit_logfile,'(A)') '================================================================'
	write(unit_logfile,'(A)') 'Redistribute local source using dispersion (uEMEP_disperse_local_source)'
	write(unit_logfile,'(A)') '================================================================'

    !If EMEP gridded to subgrid files already exist then read them in and leave the subroutine
    do subsource_index=1,n_subsource(source_index)
    temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//trim(subsource_str(subsource_index))//'_'//trim(file_tag)//'.asc'
    if (read_existing_grid_data(subgrid_local_file_index(source_index))) then
        inquire(file=temp_name,exist=exists)
        if (.not.exists) then
            write(unit_logfile,*)'ERROR: '//trim(temp_name)//' does not exist.'
            return
        endif
        call read_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,local_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
        return
    endif
    enddo

    do subsource_index=1,n_subsource(source_index)

        !Calculate redistributed subgrid source concentrations
        subgrid(:,:,:,scaling_factor_subgrid_index,source_index,subsource_index)=1.
        subgrid(:,:,:,local_subgrid_index,source_index,subsource_index)=subgrid(:,:,:,scaling_factor_subgrid_index,source_index,subsource_index)*subgrid(:,:,:,proxy_subgrid_index,source_index,subsource_index)
   
        !Save files
        if (save_intermediate_files) then
        if (.not.read_existing_grid_data(subgrid_local_file_index(source_index))) then
            !do subsource_index=1,n_subsource(source_index)
            temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//trim(subsource_str(subsource_index))//'_'//trim(file_tag)//'.asc'
            write(unit_logfile,'(a)')'Writing to: '//trim(temp_name)
            call write_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,local_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
            temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//trim(subsource_str(subsource_index))//'_sf_'//trim(file_tag)//'.asc'
            write(unit_logfile,'(a)')'Writing to: '//trim(temp_name)
            call write_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,scaling_factor_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
            !enddo
        endif
        endif
    
    enddo !Subsource loop
    
    end subroutine uEMEP_disperse_local_source
    
    
    !uEMEP_combine_local_source
    !Saves the combination of local sources for final results
    
    subroutine uEMEP_combine_local_source
    
    use uEMEP_definitions
    
    implicit none

    character(256) temp_name
    logical exists
    integer subsource_index,source_index
    integer emep_subsource
    
    emep_subsource=1
    
    write(unit_logfile,'(A)')'Combining the local and nonlocal contributions at each subgrid'

    if (interpolate_subgrids_flag) then
        write(unit_logfile,'(a)') 'Interpolate routines not currently active. Stopping'
        stop
        !call uEMEP_interpolate_subgrids
        !call uEMEP_linear_interpolate_subgrids
        !call uEMEP_bilinear_interpolate_subgrids
    endif
    
    !Calculate redistributed subgrid allsource concentrations
    subgrid(:,:,:,local_subgrid_index,allsource_index,:)=0.
    do source_index=1,n_source_index
        if (calculate_source(source_index)) then
        do subsource_index=1,n_subsource(source_index)
            subgrid(:,:,:,local_subgrid_index,allsource_index,1)=subgrid(:,:,:,local_subgrid_index,allsource_index,1)+subgrid(:,:,:,local_subgrid_index,source_index,subsource_index)
        enddo
        endif
    enddo
    
    !If the compound is PM2.5 or PM10 then add the non PPM part to the non-local
    if (compound_index.eq.pm25_index.or.compound_index.eq.pm10_index) then
        write(*,*) 'MEAN PPM NONLOCAL: ',sum((subgrid(:,:,:,emep_nonlocal_subgrid_index,allsource_index,emep_subsource)))/subgrid_dim(x_dim_index)/subgrid_dim(y_dim_index)/subgrid_dim(t_dim_index)
        subgrid(:,:,:,emep_nonlocal_subgrid_index,allsource_index,emep_subsource)=subgrid(:,:,:,emep_nonlocal_subgrid_index,allsource_index,emep_subsource) &
        +(comp_EMEP_subgrid(:,:,:,compound_index)-subgrid(:,:,:,emep_subgrid_index,allsource_index,emep_subsource))
        write(*,*) 'MEAN ADD NONLOCAL: ',sum((comp_EMEP_subgrid(:,:,:,compound_index)-subgrid(:,:,:,emep_subgrid_index,allsource_index,1)))/subgrid_dim(x_dim_index)/subgrid_dim(y_dim_index)/subgrid_dim(t_dim_index)
   endif
    
    subgrid(:,:,:,total_subgrid_index,allsource_index,1)=subgrid(:,:,:,local_subgrid_index,allsource_index,1)+subgrid(:,:,:,emep_nonlocal_subgrid_index,allsource_index,emep_subsource)
    
    !If there is no chemistry then place the results in the compound results
    if (n_compound_loop.eq.1) then
        comp_subgrid(:,:,:,compound_index)=subgrid(:,:,:,total_subgrid_index,allsource_index,1)
    endif
    
    
    !Save files
    if (save_intermediate_files) then
    subsource_index=1
    source_index=allsource_index
    if (.not.read_existing_grid_data(subgrid_local_file_index(source_index))) then
        !do subsource_index=1,n_subsource(source_index)
        temp_name=trim(pathname_grid(subgrid_local_file_index(source_index)))//trim(filename_grid(subgrid_local_file_index(source_index)))//'_'//trim(var_name_nc(conc_nc_index,compound_index,allsource_index))//'_'//trim(file_tag)//'.asc'
        write(unit_logfile,'(a)')'Writing to: '//trim(temp_name)
        call write_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,local_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
        temp_name=trim(pathname_grid(subgrid_total_file_index(source_index)))//trim(filename_grid(subgrid_total_file_index(source_index)))//'_'//trim(var_name_nc(conc_nc_index,compound_index,allsource_index))//'_'//trim(file_tag)//'.asc'
        write(unit_logfile,'(a)')'Writing to: '//trim(temp_name)
        call write_esri_ascii_3d_file(unit_logfile,temp_name,subgrid_dim(x_dim_index),subgrid_dim(y_dim_index),subgrid_dim(t_dim_index),subgrid_delta(1),subgrid(:,:,:,total_subgrid_index,source_index,subsource_index),x_subgrid,y_subgrid)
        !enddo
    endif
    endif
    
    end subroutine uEMEP_combine_local_source