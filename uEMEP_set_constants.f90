    subroutine uEMEP_set_constants
    
    use uEMEP_definitions
    
    implicit none
    
    integer i,j
    integer count
    character(256) deposition_str
    
    
    !Initialise some array flags
	replace_EMEP_local_with_subgrid_local=.false.
	calculate_source=.false.
    
    
    dim_name_nc(x_dim_nc_index)='lon'
    dim_name_nc(y_dim_nc_index)='lat'
    dim_name_nc(z_dim_nc_index)='lev'
    dim_name_nc(time_dim_nc_index)='time'
    dim_name_nc(xdist_dim_nc_index)='x_dist'
    dim_name_nc(ydist_dim_nc_index)='y_dist'


    !Sectors. Default are SNAP sectors before reading config files
    uEMEP_to_EMEP_sector=0
    uEMEP_to_EMEP_sector(traffic_index)=7
    uEMEP_to_EMEP_sector(shipping_index)=8
    uEMEP_to_EMEP_sector(agriculture_index)=10
    uEMEP_to_EMEP_sector(heating_index)=2
    uEMEP_to_EMEP_sector(industry_index)=4
    !Set replace value to -1 as flag
    uEMEP_to_EMEP_replace_sector=-1
    
        !Concentrations
        var_name_nc=''
        var_name_nc(conc_nc_index,o3_nc_index,allsource_nc_index)='o3'
        var_name_nc(conc_nc_index,no2_nc_index,allsource_nc_index)='no2'
        var_name_nc(conc_nc_index,nox_nc_index,allsource_nc_index)='nox'
        var_name_nc(conc_nc_index,nh3_nc_index,allsource_nc_index)='nh3'
        var_name_nc(conc_nc_index,nh4_nc_index,allsource_nc_index)='nh4'
        var_name_nc(conc_nc_index,pm25_nc_index,allsource_nc_index)='pm25'
        var_name_nc(conc_nc_index,pm10_nc_index,allsource_nc_index)='pm10'
        var_name_nc(conc_nc_index,pmco_nc_index,allsource_nc_index)='pmco'
        var_name_nc(conc_nc_index,pmex_nc_index,allsource_nc_index)='pmex'
        var_name_nc(conc_nc_index,all_nc_index,allsource_nc_index)='all'
        var_name_nc(conc_nc_index,all_sand_nc_index,allsource_nc_index)='all_sand'
        var_name_nc(conc_nc_index,all_sand_salt_nc_index,allsource_nc_index)='all_sand_salt'
        var_name_nc(conc_nc_index,all_salt_nc_index,allsource_nc_index)='all_salt'
        var_name_nc(conc_nc_index,all_totals_nc_index,allsource_nc_index)='all_totals'
       
        var_name_nc(conc_nc_index,pm25_sand_nc_index,allsource_nc_index)='pm25_sand'
        var_name_nc(conc_nc_index,pm10_sand_nc_index,allsource_nc_index)='pm10_sand'
        var_name_nc(conc_nc_index,pm25_salt_nc_index,allsource_nc_index)='pm25_salt'
        var_name_nc(conc_nc_index,pm10_salt_nc_index,allsource_nc_index)='pm10_salt'
        
        !Local fractions
        var_name_nc(frac_nc_index,nox_nc_index,traffic_nc_index)='nox_sec07_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,traffic_nc_index)='pmco_sec07_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,traffic_nc_index)='pm25_sec07_local_fraction'
 
        var_name_nc(frac_nc_index,nox_nc_index,shipping_nc_index)='nox_sec08_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,shipping_nc_index)='pm25_sec08_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,shipping_nc_index)='pmco_sec08_local_fraction'

        var_name_nc(frac_nc_index,nh3_nc_index,agriculture_nc_index)='nh3_sec10_local_fraction'

        var_name_nc(frac_nc_index,nox_nc_index,heating_nc_index)='nox_sec02_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,heating_nc_index)='pm25_sec02_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,heating_nc_index)='pmco_sec02_local_fraction'

        !SNAP 1 is energy, SNAP 3 is combustion in manufacturing and SNAP 4 is process, all should be used but in Norway it is mostly process???
        var_name_nc(frac_nc_index,nox_nc_index,industry_nc_index)='nox_sec04_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,industry_nc_index)='pm25_sec04_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,industry_nc_index)='pmco_sec04_local_fraction'

        !Total emissions
        var_name_nc(emis_nc_index,nh3_nc_index,allsource_nc_index)='Emis_mgm2_nh3'
        var_name_nc(emis_nc_index,nox_nc_index,allsource_nc_index)='Emis_mgm2_nox'
        var_name_nc(emis_nc_index,pmco_nc_index,allsource_nc_index)='Emis_mgm2_pmco'
        var_name_nc(emis_nc_index,pm25_nc_index,allsource_nc_index)='Emis_mgm2_pm25'
        
        !Sector emissions
        var_name_nc(emis_nc_index,nh3_nc_index,agriculture_nc_index)='Emis_mgm2_nh3'

        var_name_nc(emis_nc_index,nox_nc_index,traffic_nc_index)='Emis_mgm2_sec7nox'
        var_name_nc(emis_nc_index,pm25_nc_index,traffic_nc_index)='Emis_mgm2_sec7pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,traffic_nc_index)='Emis_mgm2_sec7pmco'

        var_name_nc(emis_nc_index,nox_nc_index,shipping_nc_index)='Emis_mgm2_sec8nox'
        var_name_nc(emis_nc_index,pm25_nc_index,shipping_nc_index)='Emis_mgm2_sec8pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,shipping_nc_index)='Emis_mgm2_sec8pmco'
        
        var_name_nc(emis_nc_index,nox_nc_index,heating_nc_index)='Emis_mgm2_sec2nox'
        var_name_nc(emis_nc_index,pm25_nc_index,heating_nc_index)='Emis_mgm2_sec2pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,heating_nc_index)='Emis_mgm2_sec2pmco'
              
        var_name_nc(emis_nc_index,nox_nc_index,industry_nc_index)='Emis_mgm2_sec4nox'
        var_name_nc(emis_nc_index,pm25_nc_index,industry_nc_index)='Emis_mgm2_sec4pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,industry_nc_index)='Emis_mgm2_sec4pmco'

        !Meteorology
        var_name_nc(ugrid_nc_index,all_nc_index,allsource_nc_index)='u_wind'
        var_name_nc(vgrid_nc_index,all_nc_index,allsource_nc_index)='v_wind'
        var_name_nc(FFgrid_nc_index,all_nc_index,allsource_nc_index)='wind_speed'
        var_name_nc(FF10_nc_index,all_nc_index,allsource_nc_index)='ws10m'
        var_name_nc(inv_FFgrid_nc_index,all_nc_index,allsource_nc_index)='inv_wind_speed'
        var_name_nc(inv_FF10_nc_index,all_nc_index,allsource_nc_index)='inv_ws10m'
        var_name_nc(hmix_nc_index,all_nc_index,allsource_nc_index)='HMIX'
        var_name_nc(kz_nc_index,all_nc_index,allsource_nc_index)='Kz'
        var_name_nc(ustar_nc_index,all_nc_index,allsource_nc_index)='met2d_ustar_nwp'
        var_name_nc(logz0_nc_index,all_nc_index,allsource_nc_index)='av_logz0'
        var_name_nc(invL_nc_index,all_nc_index,allsource_nc_index)='inv_L'
        var_name_nc(J_nc_index,all_nc_index,allsource_nc_index)='J(NO2)'
        var_name_nc(ZTOP_nc_index,all_nc_index,allsource_nc_index)='Z_TOP'
        var_name_nc(t2m_nc_index,all_nc_index,allsource_nc_index)='met2d_t2m'
        var_name_nc(precip_nc_index,all_nc_index,allsource_nc_index)='WDEP_PREC'!'precipitations'
        surface_level_nc=7 !Will be reset as length of 'lev' dimension

        !Alternative meteorology.
        dim_name_meteo_nc(x_dim_nc_index)='x'
        dim_name_meteo_nc(y_dim_nc_index)='y'
        dim_name_meteo_nc(z_dim_nc_index)='height3'
        dim_name_meteo_nc(time_dim_nc_index)='time'

        var_name_meteo_nc=''
        !Depends which file you read unfortunately. My files lat, MEPS latitude WHY?
        !Put these in the config file
        !var_name_meteo_nc(lon_nc_index)='lon'
        !var_name_meteo_nc(lat_nc_index)='lat'
        var_name_meteo_nc(lon_nc_index)='longitude'
        var_name_meteo_nc(lat_nc_index)='latitude'
        var_name_meteo_nc(ugrid_nc_index)='u_wind' !!Doesn't exist but name is used
        var_name_meteo_nc(vgrid_nc_index)='v_wind' !!Doesn't exist but name is used
        var_name_meteo_nc(FFgrid_nc_index)='FF_wind' !Doesn't exist but name is used
        var_name_meteo_nc(FF10_nc_index)='wind_speed' 
        var_name_meteo_nc(inv_FFgrid_nc_index)='' 
        var_name_meteo_nc(inv_FF10_nc_index)='' 
        var_name_meteo_nc(hmix_nc_index)='atmosphere_boundary_layer_thickness'
        var_name_meteo_nc(kz_nc_index)=''
        var_name_meteo_nc(ustar_nc_index)='ustar' !Doesn't exist but name is used
        var_name_meteo_nc(logz0_nc_index)='Z0' !Needs to be converted to log(Z0)
        var_name_meteo_nc(invL_nc_index)='invL' !!Doesn't exist but name is used. Will be calculated
        var_name_meteo_nc(J_nc_index)=''
        var_name_meteo_nc(ZTOP_nc_index)=''
        var_name_meteo_nc(t2m_nc_index)='air_temperature_2m'
        var_name_meteo_nc(precip_nc_index)='precipitation_amount_acc'
        
        !Additional     parameter (u10_nc_subgrid_index=22,v10_nc_subgrid_index=23,uw_nc_subgrid_index=24,vw_nc_subgrid_index=25,Hflux_nc_subgrid_index=26)
        var_name_meteo_nc(u10_nc_index)='x_wind_10m' !10 m wind not grid. Replaces ugrid. Used for direction
        var_name_meteo_nc(v10_nc_index)='y_wind_10m' !10 m wind not grid. Replaces vgrid. Used for direction
        var_name_meteo_nc(uw_nc_index)='downward_eastward_momentum_flux_in_air' !Will be used to determine ustar
        var_name_meteo_nc(vw_nc_index)='downward_northward_momentum_flux_in_air' !Will be used to determine ustar
        var_name_meteo_nc(Hflux_nc_index)='integral_of_surface_downward_sensible_heat_flux_wrt_time'

        !var_name_meteo_nc(rh2m_nc_index)='relative_humidity_2m'
        !var_name_meteo_nc(t0m_nc_index)='air_temperature_0m'
        !var_name_meteo_nc(t12m_nc_index)='air_temperature_ml' !This is at level 0
        !var_name_meteo_nc(t100m_nc_index)='air_temperature_ml' !This is at model level 4 (0-4)
        !var_name_meteo_nc(SWflux_nc_index)='integral_of_surface_downwelling_shortwave_flux_in_air_wrt_time'
        !var_name_meteo_nc(LWflux_nc_index)='integral_of_surface_downwelling_longwave_flux_in_air_wrt_time'
        !var_name_meteo_nc(cloudcover_nc_index)='cloud_area_fraction'
        !var_name_meteo_nc(rain_nc_index)='precipitation_amount_acc'
        !var_name_meteo_nc(snow_nc_index)='snowfall_amount_acc'
        !var_name_meteo_nc(pressure_nc_index)='surface_air_pressure'
        
        !dim_name_population_nc(x_dim_nc_index)='x'
        !dim_name_population_nc(y_dim_nc_index)='y'
        dim_name_population_nc(x_dim_nc_index)='lon'
        dim_name_population_nc(y_dim_nc_index)='lat'
        !var_name_population_nc(lon_nc_index)='lon'
        !var_name_population_nc(lat_nc_index)='lat'
        var_name_population_nc(population_nc_index)='Band1'
        var_name_population_nc(dwelling_nc_index)='Band1'

        dim_name_shipping_nc(x_dim_nc_index)='lon'
        dim_name_shipping_nc(y_dim_nc_index)='lat'
        var_name_shipping_nc(population_nc_index)='nox'
       
        !Additional compounds for chemistry and totals
        comp_name_nc=''
        comp_name_nc(o3_nc_index)='D3_ug_O3'
        comp_name_nc(no2_nc_index)='D3_ug_NO2'
        comp_name_nc(nox_nc_index)='D3_ugN_NOX'
        comp_name_nc(nh3_nc_index)='D3_ug_NH3'
        !comp_name_nc(nh3_nc_index)='nh3'
        comp_name_nc(nh4_nc_index)='D3_ug_NH4_F'
        !comp_name_nc(pm25_nc_index)='pm25'
        !comp_name_nc(pmco_nc_index)='D3_ug_PMCO'
        comp_name_nc(pm10_nc_index)='D3_ug_PM10'
        comp_name_nc(pm25_nc_index)='D3_ug_PMFINE'
        comp_name_nc(pmex_nc_index)='Exhaust'
        !comp_name_nc(pm25_nc_index)='SURF_ug_PM25_rh50'

        comp_name_nc(pm25_sand_nc_index)='PM25_sand'
        comp_name_nc(pm10_sand_nc_index)='PM10_sand'
        comp_name_nc(pm25_salt_nc_index)='PM25_salt'
        comp_name_nc(pm10_salt_nc_index)='PM10_salt'

        !Additional speciation of PM from EMEP
        species_name_nc(pm10_sp_index,sp_soa_index)='pm10_EMEP_soa'
        species_name_nc(pm25_sp_index,sp_soa_index)='pm25_EMEP_soa'
            species_name_nc(pm25_sp_index,sp_asoa_index)='SURF_ug_ASOA'
            species_name_nc(pm25_sp_index,sp_bsoa_index)='SURF_ug_BSOA'
        
        species_name_nc(pm10_sp_index,sp_sia_index)='pm10_EMEP_sia'
        species_name_nc(pm25_sp_index,sp_sia_index)='pm25_EMEP_sia'
            species_name_nc(pm10_sp_index,sp_sia_in_index)='SURF_ug_SIA'
            species_name_nc(pm25_sp_index,sp_no3_index)='SURF_ug_NO3_F'
            species_name_nc(pm25_sp_index,sp_so4_index)='SURF_ug_SO4'
            species_name_nc(pm25_sp_index,sp_nh4_index)='SURF_ug_NH4_F'
            species_name_nc(pmco_sp_index,sp_no3_index)='SURF_ug_NO3_C'

        species_name_nc(pm10_sp_index,sp_dust_index)='pm10_EMEP_dust'
        species_name_nc(pm25_sp_index,sp_dust_index)='pm25_EMEP_dust'
        species_name_nc(pmco_sp_index,sp_dust_index)='pmco_EMEP_dust'
            species_name_nc(pmco_sp_index,sp_dust_sah_index)='SURF_ug_DUST_SAH_C'
            species_name_nc(pm25_sp_index,sp_dust_sah_index)='SURF_ug_DUST_SAH_F'
            species_name_nc(pmco_sp_index,sp_dust_wb_index)='SURF_ug_DUST_WB_C'
            species_name_nc(pm25_sp_index,sp_dust_wb_index)='SURF_ug_DUST_WB_F'
        
        species_name_nc(pm25_sp_index,sp_seasalt_index)='pm25_EMEP_seasalt'
        species_name_nc(pm10_sp_index,sp_seasalt_index)='pm10_EMEP_seasalt'
            species_name_nc(pm25_sp_index,sp_seasalt_in_index)='SURF_ug_SEASALT_F'
            species_name_nc(pmco_sp_index,sp_seasalt_in_index)='SURF_ug_SEASALT_C'

        species_name_nc(pm10_sp_index,sp_ffire_index)='pm10_EMEP_fire'
        species_name_nc(pm25_sp_index,sp_ffire_index)='pm25_EMEP_fire'
            species_name_nc(pm25_sp_index,sp_ffire_bc_index)='SURF_ug_FFIRE_BC'
            species_name_nc(pm25_sp_index,sp_ffire_rem_index)='SURF_ug_FFIRE_REMPPM25'

        species_name_nc(pm10_sp_index,sp_ppm_index)='pm10_EMEP_ppm'
        species_name_nc(pm25_sp_index,sp_ppm_index)='pm25_EMEP_ppm'
        species_name_nc(pm10_sp_index,sp_ppm_in_index)='SURF_ug_PPM10'
        species_name_nc(pm25_sp_index,sp_ppm_in_index)='SURF_ug_PPM25'
        species_name_nc(pmco_sp_index,sp_ppm_in_index)='SURF_ug_PPM_C'

        species_name_nc(pm10_sp_index,sp_pm_index)='pm10_EMEP_total'
        species_name_nc(pm25_sp_index,sp_pm_index)='pm25_EMEP_total'
        species_name_nc(pm10_sp_index,sp_pm_in_index)='SURF_ug_PM10'
        species_name_nc(pm25_sp_index,sp_pm_in_index)='SURF_ug_PMFINE'
        !species_name_nc(pm25_sp_index,sp_pm_in_index)='SURF_ug_PM25'
        species_name_nc(pmco_sp_index,sp_pm_in_index)='SURF_ug_PMCO'

        species_name_nc(pm10_sp_index,sp_water_index)='pm10_EMEP_water'
        species_name_nc(pm25_sp_index,sp_water_index)='pm25_EMEP_water'
        species_name_nc(pm10_sp_index,sp_water_in_index)=''
        !species_name_nc(pm25_sp_index,sp_pm_in_index)='SURF_ug_PMFINE'
        species_name_nc(pm25_sp_index,sp_water_in_index)='SURF_PM25water'

        !Deposition names
        deposition_name_nc=''
            i=nh3_nc_index
            if (i.eq.nh3_nc_index) deposition_str='NH3'
            deposition_name_nc(temp_conif_index,i)='MSC_VG_'//trim(deposition_str)//'_CF'
            deposition_name_nc(temp_decid_index,i)='MSC_VG_'//trim(deposition_str)//'_DF'
            deposition_name_nc(med_needle_index,i)='MSC_VG_'//trim(deposition_str)//'_NF'
            deposition_name_nc(med_broadleaf_index,i)='MSC_VG_'//trim(deposition_str)//'_BF'
            deposition_name_nc(temp_crop_index,i)='MSC_VG_'//trim(deposition_str)//'_TC'
            deposition_name_nc(med_crop_index,i)='MSC_VG_'//trim(deposition_str)//'_MC'
            deposition_name_nc(root_crop_index,i)='MSC_VG_'//trim(deposition_str)//'_RC'
            deposition_name_nc(moorland_index,i)='MSC_VG_'//trim(deposition_str)//'_SNL'
            deposition_name_nc(grass_index,i)='MSC_VG_'//trim(deposition_str)//'_GR'
            deposition_name_nc(medscrub_index,i)='MSC_VG_'//trim(deposition_str)//'_MS'
            deposition_name_nc(wetlands_index,i)='MSC_VG_'//trim(deposition_str)//'_WE'
            deposition_name_nc(tundra_index,i)='MSC_VG_'//trim(deposition_str)//'_TU'
            deposition_name_nc(desert_index,i)='MSC_VG_'//trim(deposition_str)//'_DE'
            deposition_name_nc(water_index,i)='MSC_VG_'//trim(deposition_str)//'_W'
            deposition_name_nc(ice_index,i)='MSC_VG_'//trim(deposition_str)//'_ICE'
            deposition_name_nc(urban_index,i)='MSC_VG_'//trim(deposition_str)//'_U'
            deposition_name_nc(grid_index,i)='MSC_VG_'//trim(deposition_str)//'_Grid'
        
            var_name_nc(wetdepo_nc_index,i,allsource_nc_index)='WDEP_'//trim(deposition_str)
            var_name_nc(drydepo_nc_index,i,allsource_nc_index)='DDEP_'//trim(deposition_str)//'_m2Grid'

        comp_scale_nc(:)=1.
        comp_scale_nc(nox_nc_index)=(14.+2.*16.)/14. !Value read in is in ugN converted to nh3
        depo_scale_nc(:)=1.
        depo_scale_nc(nh3_nc_index)=(14.+3.*1.)/14. !Value read in is in ugN converted to nh3


        
        !Allocate the indexes for specifying compound and sources together. Never used and not correct either!!!
    count=0
    do i=1,size(compound_source_index,1)
        do j=1,size(compound_source_index,2)
            count=count+1
            compound_source_index(i,j)=count
        enddo
    enddo
    
     
    !Allocate source strings for writing to files
    source_file_str(allsource_index)='allsources'
    source_file_str(traffic_index)='traffic'
    source_file_str(shipping_index)='shipping'
    source_file_str(agriculture_index)='agriculture'
    source_file_str(heating_index)='heating'
    source_file_str(industry_index)='industry'

    do i=1,n_pollutant_nc_index
        pollutant_file_str(i)=var_name_nc(conc_nc_index,i,allsource_nc_index)
    enddo
    
    !do i=1,n_possible_subsource
    !    write(str_temp,'(i1)') i
    !    subsource_str(i)='_'//trim(str_temp)
    !enddo
    
    
    !Set filename indexes for grids generated by uEMEP
    do i=1,n_source_index
        j=j+1;proxy_emission_file_index(i)=j
        j=j+1;emission_file_index(i)=j
        j=j+1;proxy_file_index(i)=j
        j=j+1;proxy_integral_file_index(i)=j
        j=j+1;emep_subgrid_file_index(i)=j
        j=j+1;emep_subgrid_nonlocal_file_index(i)=j
        j=j+1;emep_subgrid_local_file_index(i)=j
        j=j+1;emep_subgrid_frac_file_index(i)=j
        j=j+1;subgrid_local_file_index(i)=j
        j=j+1;subgrid_total_file_index(i)=j
        j=j+1;use_subgrid_file_index(i)=j
        j=j+1;emep_emission_subgrid_file_index(i)=j
    enddo
    do i=1,n_population_index
        j=j+1;population_file_index(i)=j
    enddo
    j=j+1;subgrid_ugrid_file_index=j
    j=j+1;subgrid_vgrid_file_index=j
    j=j+1;subgrid_hmix_file_index=j
    j=j+1;subgrid_kz_file_index=j
    j=j+1;subgrid_logz0_file_index=j
    j=j+1;subgrid_invL_file_index=j     
    j=j+1;subgrid_FFgrid_file_index=j     
    j=j+1;subgrid_FF10_file_index=j
    j=j+1;subgrid_DDgrid_file_index=j     
    j=j+1;subgrid_DD10_file_index=j
    j=j+1;subgrid_invFFgrid_file_index=j     
    j=j+1;subgrid_invFF10_file_index=j
    j=j+1;subgrid_ustar_file_index=j
    j=j+1;subgrid_t2m_file_index=j
    j=j+1;subgrid_J_file_index=j
    j=j+1;subgrid_meteo_file_index=j
    
    
    
    
    !Set initial values  for the dispersion parameters
    sig_y_00=0.
    sig_z_00=0.
    h_emis=0.
    z_rec=2.
    
    h_emis(traffic_index,:)=2.
    h_emis(shipping_index,:)=25.
    h_emis(heating_index,:)=25.
    h_emis(agriculture_index,:)=1.
    h_emis(industry_index,:)=25.
    sig_y_00(shipping_index,:)=5.
    sig_y_00(traffic_index,:)=1.
    sig_y_00(heating_index,:)=5.
    sig_y_00(agriculture_index,:)=5.
    sig_y_00(industry_index,:)=5.
    sig_z_00(shipping_index,:)=5.
    sig_z_00(traffic_index,:)=1.
    sig_z_00(heating_index,:)=10.
    sig_z_00(agriculture_index,:)=10.
    sig_z_00(industry_index,:)=10.

    !Set all emission factors to unity
    emission_factor=1.
    
    !Preset all initial emission factors 
    emission_factor(nox_index,traffic_index,:)=0.4 !(g/km/veh)
    emission_factor(nox_index,shipping_index,:)=1. !Shipping data is in emissions [tonne/month]
    emission_factor(nox_index,heating_index,:)=3./15. !(kg/dwelling/year) Estimate only
    emission_factor(nox_index,industry_index,:)=1. !Industry data is in emissions [tonne/year]

    emission_factor(no2_index,traffic_index,:)=0.15*emission_factor(nox_index,traffic_index,:)
    emission_factor(no2_index,shipping_index,:)=0.10*emission_factor(nox_index,shipping_index,:)
    emission_factor(no2_index,heating_index,:)=0.1*emission_factor(nox_index,heating_index,:)!(kg/dwelling/year) Estimate only
    emission_factor(no2_index,industry_index,:)=0.10*emission_factor(nox_index,shipping_index,:)

    emission_factor(pm25_index,traffic_index,:)=0.01 !(g/km/veh)
    emission_factor(pm25_index,shipping_index,:)=1. !Shipping data is in emissions [tonne/month]
    emission_factor(pm25_index,heating_index,:)=3. !(kg/dwelling/year) SSB number is 6
    emission_factor(pm25_index,industry_index,:)=1. 

    emission_factor(pm10_index,traffic_index,:)=0.01 !(g/km/veh)
    emission_factor(pm10_index,shipping_index,:)=1. !Shipping data is in emissions [tonne/month]
    emission_factor(pm10_index,heating_index,:)=3. !(kg/dwelling/year) SSB number is 6
    emission_factor(pm10_index,industry_index,:)=1. 

    emission_factor(pmex_index,traffic_index,:)=0.01 !(g/km/veh)

    emission_factor(nh3_index,agriculture_index,:)=1. !Agriculture data is in emissions [kg/yr]
    emission_factor(nh4_index,agriculture_index,:)=1. !Agriculture data is in emissions [kg/yr]

    ratio_truck_car_emission(nox_index)=12.5 !4.86/.318 !From excel sheet for NOx. 12.5 matches the values used in NORTRIP
    ratio_truck_car_emission(no2_index)=12.5 !4.86/.318 !Should perhaps be different but 
    ratio_truck_car_emission(pm25_index)=10.
    ratio_truck_car_emission(pm10_index)=10.
    ratio_truck_car_emission(pmex_index)=10.

    !Set AQI thresholds
    aqi_hourly_limits(no2_index,1)=100.;aqi_hourly_limits(no2_index,2)=200.;aqi_hourly_limits(no2_index,3)=400.;
    !aqi_hourly_limits(pm10_index,1)=50.;aqi_hourly_limits(pm10_index,2)=80.;aqi_hourly_limits(pm10_index,3)=400.;
    !aqi_hourly_limits(pm25_index,1)=25.;aqi_hourly_limits(pm25_index,2)=40.;aqi_hourly_limits(pm25_index,3)=150.;
    aqi_hourly_limits(pm10_index,1)=60.;aqi_hourly_limits(pm10_index,2)=120.;aqi_hourly_limits(pm10_index,3)=400.;
    aqi_hourly_limits(pm25_index,1)=30.;aqi_hourly_limits(pm25_index,2)=50.;aqi_hourly_limits(pm25_index,3)=150.;
    aqi_hourly_limits(o3_index,1)=100.;aqi_hourly_limits(o3_index,2)=180.;aqi_hourly_limits(o3_index,3)=240.;

    aqi_daily_limits(pm10_index,1)=30.;aqi_daily_limits(pm10_index,2)=50.;aqi_daily_limits(pm10_index,3)=150.;
    aqi_daily_limits(pm25_index,1)=15.;aqi_daily_limits(pm25_index,2)=25.;aqi_daily_limits(pm25_index,3)=75.;

    !Not properly defined
    aqi_annual_limits(no2_index,1)=0.;aqi_annual_limits(no2_index,2)=40.;aqi_annual_limits(no2_index,3)=40.;
    aqi_annual_limits(pm10_index,1)=0.;aqi_annual_limits(pm10_index,2)=25.;aqi_annual_limits(pm10_index,3)=35.;
    aqi_annual_limits(pm25_index,1)=0.;aqi_annual_limits(pm25_index,2)=15.;aqi_annual_limits(pm25_index,3)=25.;

    !For temperature scaling
    traffic_nox_emission_temperature_ref_temperature(1)=-15.
    traffic_nox_emission_temperature_ref_temperature(2)=5.
    traffic_nox_emission_temperature_ref_scaling(1)=3.
    traffic_nox_emission_temperature_ref_scaling(2)=1.
    
    !EMEP projection default (LCC)
    EMEP_projection_type=LCC_projection_index
    EMEP_projection_attributes(1) = 63.0 !Standard parallel 1
    EMEP_projection_attributes(2) = 63.0 !Standard parallel 2
    EMEP_projection_attributes(3) = 15.0 !lon0
    EMEP_projection_attributes(4) = 63.0 !lat0
    EMEP_projection_attributes(5) = 6370000.0 !earth_radius
    EMEP_projection_attributes(6) = 1.e12 !flattening spherical earth

    !uEMEP projection default (UTM)
    projection_type=UTM_projection_index
    projection_attributes(1) = utm_zone
    projection_attributes(2) = utm_lon0

    !uEMEP projection alternative (LAEA) for European modelling. Can copy to config file if it is to be used
    !projection_type=LAEA_projection_index
    !projection_attributes(1) = 10.  !lon0
    !projection_attributes(2) = 52.  !lat0
    !projection_attributes(3) = 4321000.  !false_easting
    !projection_attributes(4) = 3210000.  !false_northing
    !projection_attributes(5) = 6370000.0  !earth_radius


    end subroutine uEMEP_set_constants
    
    subroutine uEMEP_set_pollutant_loop
    
    use uEMEP_definitions
    
    implicit none
    
    integer p_loop
    
        !Set the pollutant index loops after reading in pollutant_index
        !Remove the sand and salt PM2.5, not necessary. Fixed ratio if needed n_pollutant_loop=6
        if (pollutant_index.eq.all_sand_salt_nc_index) then
            n_emep_pollutant_loop=3
            n_pollutant_loop=6
            pollutant_loop_index(1)=nox_nc_index
            pollutant_loop_index(2)=pm25_nc_index
            pollutant_loop_index(3)=pm10_nc_index
            pollutant_loop_index(4)=pmex_nc_index
            pollutant_loop_index(5)=pm10_sand_nc_index
            pollutant_loop_index(6)=pm10_salt_nc_index
            pollutant_loop_index(7)=pm25_sand_nc_index
            pollutant_loop_index(8)=pm25_salt_nc_index
            pollutant_loop_back_index(nox_nc_index)=1
            pollutant_loop_back_index(pm25_nc_index)=2
            pollutant_loop_back_index(pm10_nc_index)=3
            pollutant_loop_back_index(pmex_nc_index)=4
            pollutant_loop_back_index(pm10_sand_nc_index)=5
            pollutant_loop_back_index(pm10_salt_nc_index)=6
            pollutant_loop_back_index(pm25_sand_nc_index)=7
            pollutant_loop_back_index(pm25_salt_nc_index)=8
        elseif (pollutant_index.eq.all_salt_nc_index) then
            n_emep_pollutant_loop=3
            n_pollutant_loop=5
            pollutant_loop_index(1)=nox_nc_index
            pollutant_loop_index(2)=pm25_nc_index
            pollutant_loop_index(3)=pm10_nc_index
            pollutant_loop_index(4)=pmex_nc_index
            pollutant_loop_index(5)=pm10_salt_nc_index
            pollutant_loop_index(6)=pm25_salt_nc_index
            pollutant_loop_back_index(nox_nc_index)=1
            pollutant_loop_back_index(pm25_nc_index)=2
            pollutant_loop_back_index(pm10_nc_index)=3
            pollutant_loop_back_index(pmex_nc_index)=4
            pollutant_loop_back_index(pm10_salt_nc_index)=5
            pollutant_loop_back_index(pm25_salt_nc_index)=6
        elseif (pollutant_index.eq.all_sand_nc_index) then
            n_emep_pollutant_loop=3
            n_pollutant_loop=5
            pollutant_loop_index(1)=nox_nc_index
            pollutant_loop_index(2)=pm25_nc_index
            pollutant_loop_index(3)=pm10_nc_index
            pollutant_loop_index(4)=pmex_nc_index
            pollutant_loop_index(5)=pm10_sand_nc_index
            pollutant_loop_index(6)=pm25_sand_nc_index
            pollutant_loop_back_index(nox_nc_index)=1
            pollutant_loop_back_index(pm25_nc_index)=2
            pollutant_loop_back_index(pm10_nc_index)=3
            pollutant_loop_back_index(pmex_nc_index)=4
            pollutant_loop_back_index(pm10_sand_nc_index)=5
            pollutant_loop_back_index(pm25_sand_nc_index)=6
        elseif (pollutant_index.eq.all_nc_index) then
            n_emep_pollutant_loop=3
            n_pollutant_loop=4
            pollutant_loop_index(1)=nox_nc_index
            pollutant_loop_index(2)=pm25_nc_index
            pollutant_loop_index(3)=pm10_nc_index
            pollutant_loop_index(4)=pmex_nc_index
            pollutant_loop_back_index(nox_nc_index)=1
            pollutant_loop_back_index(pm25_nc_index)=2
            pollutant_loop_back_index(pm10_nc_index)=3
            pollutant_loop_back_index(pmex_nc_index)=4
        elseif (pollutant_index.eq.all_totals_nc_index) then
            n_emep_pollutant_loop=3
            n_pollutant_loop=3
            pollutant_loop_index(1)=nox_nc_index
            pollutant_loop_index(2)=pm25_nc_index
            pollutant_loop_index(3)=pm10_nc_index
            pollutant_loop_back_index(nox_nc_index)=1
            pollutant_loop_back_index(pm25_nc_index)=2
            pollutant_loop_back_index(pm10_nc_index)=3
        elseif (pollutant_index.eq.pm_nc_index) then
            n_emep_pollutant_loop=2
            n_pollutant_loop=3
            pollutant_loop_index(1)=pm25_nc_index
            pollutant_loop_index(2)=pm10_nc_index
            pollutant_loop_index(3)=pmex_nc_index
            pollutant_loop_back_index(pm25_nc_index)=1
            pollutant_loop_back_index(pm10_nc_index)=2
            pollutant_loop_back_index(pmex_nc_index)=3
        elseif (pollutant_index.eq.nh3_nc_index) then
            n_emep_pollutant_loop=1
            n_pollutant_loop=1
            pollutant_loop_index(1)=nh3_nc_index
            pollutant_loop_index(2)=nh4_nc_index
            pollutant_loop_back_index(nh3_nc_index)=1
            pollutant_loop_back_index(nh4_nc_index)=2
        else
            n_emep_pollutant_loop=1
            n_pollutant_loop=1
            pollutant_loop_index(1)=pollutant_index
            pollutant_loop_back_index(pollutant_index)=1
            !write(*,*) pollutant_loop_index(1),pollutant_index
            
        endif
        
        !Set indexing for additional compounds. Only used when reading in EMEP data
        do p_loop=1,n_pollutant_loop
        if (pollutant_loop_index(p_loop).eq.nox_nc_index) then
            n_pollutant_compound_loop(p_loop)=3
            pollutant_compound_loop_index(p_loop,1)=nox_nc_index
            pollutant_compound_loop_index(p_loop,2)=no2_nc_index
            pollutant_compound_loop_index(p_loop,3)=o3_nc_index
        elseif (pollutant_loop_index(p_loop).eq.nh3_nc_index) then
            n_pollutant_compound_loop(p_loop)=2
            pollutant_compound_loop_index(p_loop,1)=nh3_nc_index
            pollutant_compound_loop_index(p_loop,2)=nh4_nc_index
        else
            n_pollutant_compound_loop(p_loop)=1
            pollutant_compound_loop_index(p_loop,1)=pollutant_loop_index(p_loop)
        endif       
        enddo
        
        write(unit_logfile,'(a,i)') 'Number of pollutants=',n_pollutant_loop
        write(unit_logfile,'(a,i)') 'Number of EMEP pollutants=',n_emep_pollutant_loop
        
    end subroutine uEMEP_set_pollutant_loop

    subroutine uEMEP_set_species_loop
    
    use uEMEP_definitions
    
    implicit none
    
    integer s_loop
    
        !Set the pollutant index loops after reading in pollutant_index
        !Remove the sand and salt PM2.5, not necessary. Fixed ratio if needed n_pollutant_loop=6
        if (save_emep_species) then
            n_species_loop_index=n_sp_index
            do s_loop=1,n_species_loop_index
                species_loop_index(s_loop)=s_loop
            enddo
        elseif (save_seasalt) then
            n_species_loop_index=1
            species_loop_index(1)=sp_seasalt_index
        else
            !No species will be read or chosen. Set to 0 to make sure it fails if they are
            n_species_loop_index=1
            species_loop_index(1)=0
        endif
                
        write(unit_logfile,'(a,i)') 'Number of species=',n_species_loop_index
        
    end subroutine uEMEP_set_species_loop


    subroutine uEMEP_reset_constants
    !Reset some constants based on the configuration file input
    use uEMEP_definitions
    implicit none
    
    integer index_start
    character(256) prefix_str,postfix_str
    integer i
    character(8) sector_str_lf,sector_str_emis
    integer sector_index
    
     if (index(alternative_meteorology_type,'nortrip').gt.0) then
        var_name_meteo_nc(lon_nc_index)='lon'
        var_name_meteo_nc(lat_nc_index)='lat'
     endif
     
    !Reset meteorological names
    if (index(alternative_meteorology_type,'nbv').gt.0) then
        dim_name_meteo_nc(z_dim_nc_index)='height4'
        var_name_meteo_nc(lon_nc_index)='lon'
        var_name_meteo_nc(lat_nc_index)='lat'
        var_name_meteo_nc(hmix_nc_index)='boundary_layer_height'
        var_name_meteo_nc(logz0_nc_index)='surface_roughness_momentum' !Needs to be converted to log(Z0)
        var_name_meteo_nc(Hflux_nc_index)='surface_upward_sensible_heat_flux'     !Note this is upward not downward so must have a negative when read 
        var_name_meteo_nc(precip_nc_index)='precipitation_amount'      
    endif
    
    if (use_EMEP_surface_ozone_flag) then
        comp_name_nc(o3_nc_index)='SURF_ug_O3'        
    endif
    

    !Set the emission sector index to be read to standard GNFR.
    !Not actually used now but could be used in the loop below
    if (use_GNFR_emissions_from_EMEP_flag) then
        uEMEP_to_EMEP_sector(traffic_index)=6
        uEMEP_to_EMEP_sector(shipping_index)=7
        uEMEP_to_EMEP_sector(agriculture_index)=0
        uEMEP_to_EMEP_sector(heating_index)=3
        uEMEP_to_EMEP_sector(industry_index)=2
    endif  

    !These are for the previous EMEP version before 4.3.3
    if (use_GNFR_emissions_from_EMEP_flag) then
        
        !Local fractions        
        var_name_nc(frac_nc_index,nox_nc_index,traffic_nc_index)='nox_sec06_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,traffic_nc_index)='pmco_sec06_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,traffic_nc_index)='pm25_sec06_local_fraction'

        var_name_nc(frac_nc_index,nox_nc_index,shipping_nc_index)='nox_sec07_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,shipping_nc_index)='pm25_sec07_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,shipping_nc_index)='pmco_sec07_local_fraction'

        !var_name_nc(frac_nc_index,nh3_nc_index,agriculture_nc_index)='nh3_sec11_local_fraction'
        !var_name_nc(frac_nc_index,nh3_nc_index,agriculture_nc_index)='nh3_sec12_local_fraction'
        !Read as total for the time being as these have become two sectors now
        var_name_nc(frac_nc_index,nh3_nc_index,agriculture_nc_index)='nh3_local_fraction'

        var_name_nc(frac_nc_index,nox_nc_index,heating_nc_index)='nox_sec03_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,heating_nc_index)='pm25_sec03_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,heating_nc_index)='pmco_sec03_local_fraction'

        var_name_nc(frac_nc_index,nox_nc_index,industry_nc_index)='nox_sec02_local_fraction'
        var_name_nc(frac_nc_index,pm25_nc_index,industry_nc_index)='pm25_sec02_local_fraction'
        var_name_nc(frac_nc_index,pmco_nc_index,industry_nc_index)='pmco_sec02_local_fraction'

        !Total emissions remain the same
        var_name_nc(emis_nc_index,nh3_nc_index,allsource_nc_index)='Emis_mgm2_nh3'
        var_name_nc(emis_nc_index,nox_nc_index,allsource_nc_index)='Emis_mgm2_nox'
        var_name_nc(emis_nc_index,pmco_nc_index,allsource_nc_index)='Emis_mgm2_pmco'
        var_name_nc(emis_nc_index,pm25_nc_index,allsource_nc_index)='Emis_mgm2_pm25'
        
        !Sector emissions read as total
        var_name_nc(emis_nc_index,nh3_nc_index,agriculture_nc_index)='Emis_mgm2_nh3'

        var_name_nc(emis_nc_index,nox_nc_index,traffic_nc_index)='Emis_mgm2_sec6nox'
        var_name_nc(emis_nc_index,pm25_nc_index,traffic_nc_index)='Emis_mgm2_sec6pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,traffic_nc_index)='Emis_mgm2_sec6pmco'

        var_name_nc(emis_nc_index,nox_nc_index,shipping_nc_index)='Emis_mgm2_sec7nox'
        var_name_nc(emis_nc_index,pm25_nc_index,shipping_nc_index)='Emis_mgm2_sec7pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,shipping_nc_index)='Emis_mgm2_sec7pmco'
        
        var_name_nc(emis_nc_index,nox_nc_index,heating_nc_index)='Emis_mgm2_sec3nox'
        var_name_nc(emis_nc_index,pm25_nc_index,heating_nc_index)='Emis_mgm2_sec3pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,heating_nc_index)='Emis_mgm2_sec3pmco'
              
        var_name_nc(emis_nc_index,nox_nc_index,industry_nc_index)='Emis_mgm2_sec2nox'
        var_name_nc(emis_nc_index,pm25_nc_index,industry_nc_index)='Emis_mgm2_sec2pm25'
        var_name_nc(emis_nc_index,pmco_nc_index,industry_nc_index)='Emis_mgm2_sec2pmco'
                
    endif
    
    if (use_emission_naming_template_flag) then
        !Set the prefix and postfix part of the emission name string based on the template
        !Assumes compound is added at the end
       
        index_start=INDEX(emission_naming_template_str,'<n>')
        if (index_start.eq.0) then
            prefix_str=''
        else
            prefix_str=emission_naming_template_str(1:index_start-1)
        endif
        if (index_start+3.gt.len_trim(emission_naming_template_str)) then
            postfix_str=''
        else
            postfix_str=emission_naming_template_str(index_start+3:)
        endif
        !write(*,*) index_start,index_start+3,len_trim(emission_naming_template_str)
        if (use_GNFR_emissions_from_EMEP_flag) then
        write(unit_logfile,'(a)') 'Using emission name template for GNFR sectors: '//trim(emission_naming_template_str)
           do i=1,n_pollutant_nc_index
                !write(unit_logfile,'(a)') 'Using emission name template for: '//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                !write(*,*) i_pollutant,i
                var_name_nc(emis_nc_index,i,allsource_nc_index)=trim(prefix_str)//''//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,agriculture_nc_index)=trim(prefix_str)//''//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index)) !GNFR is 11 and 12 so currently using total
                var_name_nc(emis_nc_index,i,traffic_nc_index)=trim(prefix_str)//'6'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,shipping_nc_index)=trim(prefix_str)//'7'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,heating_nc_index)=trim(prefix_str)//'3'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,industry_nc_index)=trim(prefix_str)//'2'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                !write(unit_logfile,'(6a32)') trim(var_name_nc(emis_nc_index,i,allsource_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,agriculture_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,traffic_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,shipping_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,heating_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,industry_nc_index))
            enddo
        
        else
            write(unit_logfile,'(a)') 'Using emission name template for SNAP sectors: '//trim(emission_naming_template_str)
            
            do i=1,n_pollutant_nc_index
                !write(unit_logfile,'(a)') 'Using emission name template for: '//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                !write(*,*) i_pollutant,i
                var_name_nc(emis_nc_index,i,allsource_nc_index)=trim(prefix_str)//''//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,agriculture_nc_index)=trim(prefix_str)//'10'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,traffic_nc_index)=trim(prefix_str)//'7'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,shipping_nc_index)=trim(prefix_str)//'8'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,heating_nc_index)=trim(prefix_str)//'2'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                var_name_nc(emis_nc_index,i,industry_nc_index)=trim(prefix_str)//'4'//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                !write(unit_logfile,'(6a32)') trim(var_name_nc(emis_nc_index,i,allsource_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,agriculture_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,traffic_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,shipping_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,heating_nc_index)) &
                !                        ,trim(var_name_nc(emis_nc_index,i,industry_nc_index))
            enddo
        endif
        

    endif
 
    if (use_user_specified_sectors_flag) then
        
            write(unit_logfile,'(a)') 'Replacing sector index in EMEP (sector,pollutant,lf_name,emis_name)'
        
            do sector_index=0,n_source_nc_index
                if (calculate_source(sector_index).and.uEMEP_to_EMEP_replace_sector(sector_index).ge.0) then
                    !sector_index=traffic_nc_index
                    write(sector_str_lf,'(i0.2)') uEMEP_to_EMEP_replace_sector(sector_index)
                    write(sector_str_emis,'(i0.1)') uEMEP_to_EMEP_replace_sector(sector_index)
                    if (uEMEP_to_EMEP_replace_sector(sector_index).ne.0) then
                        sector_str_lf='_sec'//trim(sector_str_lf)
                        sector_str_emis=trim(sector_str_emis)
                    else
                        sector_str_lf=''
                        sector_str_emis=''
                    endif
                    do i=1,n_pollutant_nc_index
                        var_name_nc(frac_nc_index,i,sector_index)=trim(var_name_nc(conc_nc_index,i,allsource_nc_index))//trim(sector_str_lf)//'_local_fraction'
                        !var_name_nc(frac_nc_index,pmco_nc_index,sector_index)='pmco'//trim(sector_str)//'_local_fraction'
                        !var_name_nc(frac_nc_index,pm25_nc_index,sector_index)='pm25'//trim(sector_str)//'_local_fraction'

                        if (use_emission_naming_template_flag) then
                            var_name_nc(emis_nc_index,i,sector_index)=trim(prefix_str)//trim(sector_str_emis)//trim(postfix_str)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))
                        else
                            var_name_nc(emis_nc_index,i,sector_index)='Emis_mgm2_sec'//trim(sector_str_emis)//trim(var_name_nc(conc_nc_index,i,allsource_nc_index))      
                        endif

                        write(unit_logfile,'(2i8,a6,i2,a4,i2,a3,2a48)') sector_index,i,' from ',uEMEP_to_EMEP_sector(sector_index),' to ',uEMEP_to_EMEP_replace_sector(sector_index),' : ',trim(var_name_nc(frac_nc_index,i,sector_index)),trim(var_name_nc(emis_nc_index,i,sector_index))
                        
                    enddo
                    
                endif
            enddo
    endif
        !stop
        !write(unit_tile,'(a,i0.5)') 'tile_tag= '//trim(save_tile_tag)//'_',count

    if (use_EMEP_surface_compounds_flag) then
        write(unit_logfile,'(a)') 'Using EMEP surface compounds instead of gridded'
        comp_name_nc(o3_nc_index)='SURF_ug_O3'
        comp_name_nc(no2_nc_index)='SURF_ug_NO2'
        comp_name_nc(nox_nc_index)='SURF_ugN_NOX'
        comp_name_nc(nh3_nc_index)='SURF_ug_NH3'
        !comp_name_nc(nh3_nc_index)='nh3'
        comp_name_nc(nh4_nc_index)='SURF_ug_NH4_F'
        !comp_name_nc(pm25_nc_index)='pm25'
        !comp_name_nc(pmco_nc_index)='SURF_ug_PMCO'
        comp_name_nc(pm10_nc_index)='SURF_ug_PM10'
        comp_name_nc(pm25_nc_index)='SURF_ug_PMFINE'
    endif
    
    if (use_water_in_EMEP_surface_pm_flag) then
        write(unit_logfile,'(a)') 'Using EMEP surface PM including water (RH50)'
        comp_name_nc(pm10_nc_index)='SURF_ug_PM10_rh50'
        comp_name_nc(pm25_nc_index)='SURF_ug_PM25_rh50'         
    endif
     
    !Reset emission names so they will not be read if they are not used
    if (make_EMEP_grid_emission_data(allsource_index).or.local_subgrid_method_flag.ne.2.or.save_emissions_for_EMEP(allsource_index).or.save_emissions) then
    else
        var_name_nc(emis_nc_index,:,:)=''        
        write(unit_logfile,'(a,i)') 'Will not read or write any EMEP emission data'
    endif
    
    !If utm zones set the projection parameters to these values
    if (projection_type.eq.utm_projection_index) then    
        projection_attributes(1)=utm_zone
        projection_attributes(2)=utm_lon0
    endif
    
    
    end subroutine uEMEP_reset_constants
