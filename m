From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Sat, 28 Mar 2015 13:40:58 -0400
Message-ID: <5516E7AA.3090204@turmel.org>
References: <54ABEE54.6020707@sympatico.ca> <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl> <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl> <54B305B2.6000702@lentijn.sess.ink> <54B3F7ED.1000809@youngman.org.uk> <BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl> <54C0C73A.4080409@lentijn.sess.ink> <BLU437-SMTP28725520E940DA3707A62F81090@phx.gbl> <55160B0A.1090405@turmel.org> <55161943.1090206@sympatico.ca> <BLU436-SMTP135A84B36120ACD11B2783D81F70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP135A84B36120ACD11B2783D81F70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Callaghan <matt_callaghan@sympatico.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matt,

I didn't see this make it to linux-raid, so I'll quote more than normal=
=2E
 Oh, and convention on kernel.org is to reply-to-all, trim unnecessary
quotes, and avoid top-posting.  Please.

On 03/27/2015 11:10 PM, Matt Callaghan wrote:
> Just noticed the lsdrv [1] link to git; got it, here's the output
> {{{
> fermulator@fermmy-mdadm:~/downloads/lsdrv/lsdrv$ ./lsdrv
> PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD=
] FCH SATA Controller [AHCI mode] (rev 40)
> =E2=94=9Cscsi 0:x:x:x [Empty]
> =E2=94=94scsi 1:0:0:0 ATA      Maxtor 6Y160M0 =20
>  =E2=94=94sda 152.67g [8:0] Empty/Unknown
>   =E2=94=9Csda1 512.00m [8:1] Empty/Unknown
>   =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /boot/efi
>   =E2=94=9Csda2 148.71g [8:2] Empty/Unknown
>   =E2=94=82=E2=94=94Mounted as /dev/disk/by-uuid/5549ca2f-758a-4e04-8=
e36-cf4544bef4fb @ /
>   =E2=94=94sda3 3.46g [8:3] Empty/Unknown
> PCI [mptsas] 05:00.0 SCSI storage controller: LSI Logic / Symbios Log=
ic SAS1068E PCI-Express Fusion-MPT SAS (rev 08)
> =E2=94=9Cscsi 2:0:0:0 ATA      ST2000DL003-9VT1
> =E2=94=82=E2=94=94sdb 1.82t [8:16] Empty/Unknown
> =E2=94=82 =E2=94=94sdb1 1.82t [8:17] Empty/Unknown
> =E2=94=9Cscsi 2:0:1:0 ATA      ST2000DL003-9VT1
> =E2=94=82=E2=94=94sdc 1.82t [8:32] Empty/Unknown
> =E2=94=82 =E2=94=94sdc1 1.82t [8:33] Empty/Unknown
> =E2=94=9Cscsi 2:0:2:0 ATA      ST2000DL003-9VT1
> =E2=94=82=E2=94=94sdd 1.82t [8:48] Empty/Unknown
> =E2=94=82 =E2=94=94sdd1 1.82t [8:49] Empty/Unknown
> =E2=94=9Cscsi 2:0:3:0 ATA      ST2000VN000-1H31
> =E2=94=82=E2=94=94sde 1.82t [8:64] Empty/Unknown
> =E2=94=82 =E2=94=94sde1 1.82t [8:65] Empty/Unknown
> =E2=94=9Cscsi 2:0:4:0 ATA      ST2000DL003-9VT1
> =E2=94=82=E2=94=94sdf 1.82t [8:80] Empty/Unknown
> =E2=94=82 =E2=94=94sdf1 1.82t [8:81] Empty/Unknown
> =E2=94=9Cscsi 2:0:5:0 ATA      ST2000DL003-9VT1
> =E2=94=82=E2=94=94sdg 1.82t [8:96] Empty/Unknown
> =E2=94=82 =E2=94=94sdg1 1.82t [8:97] Empty/Unknown
> =E2=94=9Cscsi 2:0:6:0 ATA      ST2000DL003-9VT1
> =E2=94=82=E2=94=94sdh 1.82t [8:112] Empty/Unknown
> =E2=94=82 =E2=94=94sdh1 1.82t [8:113] Empty/Unknown
> =E2=94=9Cscsi 2:0:7:0 ATA      ST2000VN000-1H31
> =E2=94=82=E2=94=94sdi 1.82t [8:128] Empty/Unknown
> =E2=94=82 =E2=94=94sdi1 1.82t [8:129] Empty/Unknown
> =E2=94=94scsi 2:x:x:x [Empty]
> Other Block Devices
> =E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
> =E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
> =E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
> =E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
> =E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
> =E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
> =E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
> =E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
> =E2=94=9Cram0 64.00m [1:0] Empty/Unknown
> =E2=94=9Cram1 64.00m [1:1] Empty/Unknown
> =E2=94=9Cram2 64.00m [1:2] Empty/Unknown
> =E2=94=9Cram3 64.00m [1:3] Empty/Unknown
> =E2=94=9Cram4 64.00m [1:4] Empty/Unknown
> =E2=94=9Cram5 64.00m [1:5] Empty/Unknown
> =E2=94=9Cram6 64.00m [1:6] Empty/Unknown
> =E2=94=9Cram7 64.00m [1:7] Empty/Unknown
> =E2=94=9Cram8 64.00m [1:8] Empty/Unknown
> =E2=94=9Cram9 64.00m [1:9] Empty/Unknown
> =E2=94=9Cram10 64.00m [1:10] Empty/Unknown
> =E2=94=9Cram11 64.00m [1:11] Empty/Unknown
> =E2=94=9Cram12 64.00m [1:12] Empty/Unknown
> =E2=94=9Cram13 64.00m [1:13] Empty/Unknown
> =E2=94=9Cram14 64.00m [1:14] Empty/Unknown
> =E2=94=94ram15 64.00m [1:15] Empty/Unknown
> }}}

Ok.  Not that helpful.  I suspect you had error messages about missing
utilities.  No serial numbers.

[trim /]

> mdadm output as of NOW. But note that the output here is likely usele=
ss
> since the last thing I was trying to was getting the array back toget=
her
> as per the forum posting... (it's definitely not in the original stat=
e
> anymore...)

Yep, useless.

[trim /]

> smartctl outputs are:

/dev/sdb:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST2000DL003-9VT166
> Serial Number:    5YD0XWHR
> LU WWN Device Id: 5 000c50 02f4197f5
> Firmware Version: CC32
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5900 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Fri Mar 27 22:57:05 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM level is:     0 (vendor specific), recommended: 254
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   113   099   006    -    5185988=
0
>    3 Spin_Up_Time            PO----   093   092   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    422
>    5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
>    7 Seek_Error_Rate         POSR--   072   060   030    -    1718576=
6
>    9 Power_On_Hours          -O--CK   061   061   000    -    34871
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    71
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   099   099   000    -    1
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   094   094   000    -    6
> 190 Airflow_Temperature_Cel -O---K   059   043   045    Past 41 (5 77=
 42 35 0)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    420
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    422
> 194 Temperature_Celsius     -O---K   041   057   000    -    41 (0 13=
 0 0 0)
> 195 Hardware_ECC_Recovered  -O-RC-   017   003   000    -    51859880
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    16990890=
657845
> 241 Total_LBAs_Written      ------   100   253   000    -    73126675=
6
> 242 Total_LBAs_Read         ------   100   253   000    -    11290164=
66
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning
>=20

> SCT Error Recovery Control command not supported

Now we know why your array fell apart.  Using green and/or desktop
drives without mitigating the timeout mismatch problem.

/dev/sdc:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST2000DL003-9VT166
> Serial Number:    5YD1B1ZJ
> LU WWN Device Id: 5 000c50 02f361865
> Firmware Version: CC32
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5900 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Fri Mar 27 22:57:06 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM level is:     0 (vendor specific), recommended: 254
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   112   090   006    -    4494719=
2
>    3 Spin_Up_Time            PO----   093   092   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    68
>    5 Reallocated_Sector_Ct   PO--CK   078   078   036    -    14728
>    7 Seek_Error_Rate         POSR--   072   066   030    -    1587394=
2
>    9 Power_On_Hours          -O--CK   061   061   000    -    34875
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    74
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   001   001   000    -    823
> 188 Command_Timeout         -O--CK   100   099   000    -    65539
> 189 High_Fly_Writes         -O-RCK   093   093   000    -    7
> 190 Airflow_Temperature_Cel -O---K   058   044   045    Past 42 (2 15=
8 44 36 0)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    65
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    68
> 194 Temperature_Celsius     -O---K   042   056   000    -    42 (0 13=
 0 0 0)
> 195 Hardware_ECC_Recovered  -O-RC-   016   003   000    -    44947192
> 197 Current_Pending_Sector  -O--C-   089   089   000    -    952
                                                              ^^^^^
Wow!

> 198 Offline_Uncorrectable   ----C-   089   089   000    -    952
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    14114980=
5250605
> 241 Total_LBAs_Written      ------   100   253   000    -    32929401=
40
> 242 Total_LBAs_Read         ------   100   253   000    -    49629791=
6
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning
>=20

> SCT Error Recovery Control command not supported

And again.

/dev/sdd:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST2000DL003-9VT166
> Serial Number:    5YD15M4K
> LU WWN Device Id: 5 000c50 02f386588
> Firmware Version: CC32
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5900 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Fri Mar 27 22:57:07 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM level is:     0 (vendor specific), recommended: 254
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   117   099   006    -    1534854=
40
>    3 Spin_Up_Time            PO----   093   092   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    352
>    5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
>    7 Seek_Error_Rate         POSR--   076   060   030    -    4381920=
6
>    9 Power_On_Hours          -O--CK   061   061   000    -    35013
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    74
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   097   097   000    -    3
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   099   099   000    -    1
> 190 Airflow_Temperature_Cel -O---K   057   046   045    -    43 (Min/=
Max 36/43)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    351
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    353
> 194 Temperature_Celsius     -O---K   043   054   000    -    43 (0 11=
 0 0 0)
> 195 Hardware_ECC_Recovered  -O-RC-   021   003   000    -    15348544=
0
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    8

More Pending sectors.  These are locations where unrecoverable read
errors occurred that the firmware is waiting for an overwrite to decide
if they are fixable.

> 198 Offline_Uncorrectable   ----C-   100   100   000    -    8
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    13450119=
5876534
> 241 Total_LBAs_Written      ------   100   253   000    -    87953809=
4
> 242 Total_LBAs_Read         ------   100   253   000    -    17836621=
56
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

> SCT Error Recovery Control command not supported

Sigh.

/dev/sde:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Device Model:     ST2000VN000-1H3164
> Serial Number:    W1H25K77
> LU WWN Device Id: 5 000c50 06a40c121
> Firmware Version: SC42
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5900 rpm
> Device is:        Not in smartctl database [for details use: -P showa=
ll]
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Fri Mar 27 22:57:07 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM level is:     254 (maximum performance)
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   116   099   006    -    1170017=
36
>    3 Spin_Up_Time            PO----   096   095   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    21
>    5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
>    7 Seek_Error_Rate         POSR--   064   060   030    -    3017660
>    9 Power_On_Hours          -O--CK   085   085   000    -    13146
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    21
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   058   058   000    -    42
> 190 Airflow_Temperature_Cel -O---K   065   056   045    -    35 (Min/=
Max 35/37)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    21
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    21
> 194 Temperature_Celsius     -O---K   035   044   000    -    35 (0 16=
 0 0 0)
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

> SCT Error Recovery Control:
>             Read:      1 (0.1 seconds)
>            Write:      1 (0.1 seconds)

Interesting.  Is this the device default?  The drives I've seen that
have a default have either 4.0s or 7.0s.

/dev/sdf:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST2000DL003-9VT166
> Serial Number:    5YD18S73
> LU WWN Device Id: 5 000c50 02f3fab7d
> Firmware Version: CC32
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5900 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Fri Mar 27 22:57:07 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM level is:     0 (vendor specific), recommended: 254
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   109   099   006    -    2395116=
0
>    3 Spin_Up_Time            PO----   093   092   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    70
>    5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
>    7 Seek_Error_Rate         POSR--   075   060   030    -    3960553=
8
>    9 Power_On_Hours          -O--CK   061   061   000    -    34955
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    75
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   089   089   000    -    11
> 190 Airflow_Temperature_Cel -O---K   058   048   045    -    42 (Min/=
Max 34/42)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    69
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    70
> 194 Temperature_Celsius     -O---K   042   052   000    -    42 (0 10=
 0 0 0)
> 195 Hardware_ECC_Recovered  -O-RC-   013   003   000    -    23951160
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    19493138=
5731211
> 241 Total_LBAs_Written      ------   100   253   000    -    42089358=
45
> 242 Total_LBAs_Read         ------   100   253   000    -    38411389=
08
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

> SCT Error Recovery Control command not supported

And again.

/dev/sdg:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST2000DL003-9VT166
> Serial Number:    5YD1ACSD
> LU WWN Device Id: 5 000c50 02f31ac2f
> Firmware Version: CC32
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5900 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Fri Mar 27 22:57:08 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM level is:     0 (vendor specific), recommended: 254
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   113   099   006    -    5071184=
8
>    3 Spin_Up_Time            PO----   093   092   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    70
>    5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
>    7 Seek_Error_Rate         POSR--   075   060   030    -    4159788=
6
>    9 Power_On_Hours          -O--CK   061   061   000    -    34955
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    74
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   100   100   000    -    0
> 190 Airflow_Temperature_Cel -O---K   058   048   045    -    42 (Min/=
Max 36/43)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    69
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    70
> 194 Temperature_Celsius     -O---K   042   052   000    -    42 (0 10=
 0 0 0)
> 195 Hardware_ECC_Recovered  -O-RC-   017   003   000    -    50711848
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    12104076=
8370827
> 241 Total_LBAs_Written      ------   100   253   000    -    11735841=
09
> 242 Total_LBAs_Read         ------   100   253   000    -    12696125=
79
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

> SCT Error Recovery Control command not supported

And sigh again.  Broken record, I know.  But this is a big deal.

/dev/sdh:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda Green (AF)
> Device Model:     ST2000DL003-9VT166
> Serial Number:    5YD18S0M
> LU WWN Device Id: 5 000c50 02f3f4ec7
> Firmware Version: CC32
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    5900 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Fri Mar 27 22:57:08 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM level is:     0 (vendor specific), recommended: 254
> APM feature is:   Unavailable
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   119   099   006    -    2298785=
36
>    3 Spin_Up_Time            PO----   093   092   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    70
>    5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
>    7 Seek_Error_Rate         POSR--   075   060   030    -    3883856=
6
>    9 Power_On_Hours          -O--CK   061   061   000    -    34957
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    76
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   094   094   000    -    6
> 190 Airflow_Temperature_Cel -O---K   061   051   045    -    39 (Min/=
Max 29/40)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    69
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    70
> 194 Temperature_Celsius     -O---K   039   049   000    -    39 (0 11=
 0 0 0)
> 195 Hardware_ECC_Recovered  -O-RC-   023   003   000    -    22987853=
6
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    30356828=
883085
> 241 Total_LBAs_Written      ------   100   253   000    -    16063676
> 242 Total_LBAs_Read         ------   100   253   000    -    25580005=
14
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

> SCT Error Recovery Control command not supported

/dev/sdi:

> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Device Model:     ST2000VN000-1H3164
> Serial Number:    W1H25JXM
> LU WWN Device Id: 5 000c50 06a406dab
> Firmware Version: SC42
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5900 rpm
> Device is:        Not in smartctl database [for details use: -P showa=
ll]
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Fri Mar 27 22:57:09 2015 EDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM level is:     254 (maximum performance)
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled

> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALU=
E
>    1 Raw_Read_Error_Rate     POSR--   119   099   006    -    2185663=
52
>    3 Spin_Up_Time            PO----   096   096   000    -    0
>    4 Start_Stop_Count        -O--CK   100   100   020    -    21
>    5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
>    7 Seek_Error_Rate         POSR--   064   060   030    -    3082219
>    9 Power_On_Hours          -O--CK   085   085   000    -    13146
>   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>   12 Power_Cycle_Count       -O--CK   100   100   020    -    21
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   100   000    -    0
> 189 High_Fly_Writes         -O-RCK   050   050   000    -    50
> 190 Airflow_Temperature_Cel -O---K   064   052   045    -    36 (Min/=
Max 36/38)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    21
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    21
> 194 Temperature_Celsius     -O---K   036   048   000    -    36 (0 16=
 0 0 0)
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
>                              ||||||_ K auto-keep
>                              |||||__ C event count
>                              ||||___ R error rate
>                              |||____ S speed/performance
>                              ||_____ O updated online
>                              |______ P prefailure warning

> SCT Error Recovery Control:
>             Read:      1 (0.1 seconds)
>            Write:      1 (0.1 seconds)

So.  You have eight devices that need to make a raid6, and you have no
order information.  You have two devices with pending errors that canno=
t
help us without role #s.

=46irst, you need to deal with the timeout mismatch problem.  Only two =
of
your devices support ERC, so you will need to set long driver timeouts.

Some reading:

http://marc.info/?l=3Dlinux-raid&m=3D135811522817345&w=3D1
http://marc.info/?l=3Dlinux-raid&m=3D133665797115876&w=3D2
http://marc.info/?l=3Dlinux-raid&m=3D142504030927143&w=3D2

As for the latter link, I haven't tested that.  When I needed such
features myself, I just put the appropriate commands into rc.local.
Since then, I've retired all of my non-raid-rated drives.

Next, you need to run numerous "mdadm --create --assume-clean" attempts
to figure out your device role order.  You have 8-factorial permutation=
s
to try (40,320).  /dev/sdc and /dev/sdd have pending errors, so leave
them out (use "missing" in their places).

Your only info from the original post that shows all of the necessary
device characteristics is this:

> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 1.1
>     Feature Map : 0x2
>      Array UUID : 15d2158f:5cf74d95:fd7f5607:0e447573
>            Name : fermmy-server:2000  (local to host fermmy-server)
>   Creation Time : Fri Apr 22 01:12:07 2011
>      Raid Level : raid6
>    Raid Devices : 8
>=20
>  Avail Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
>      Array Size : 11721080448 (11178.09 GiB 12002.39 GB)
>     Data Offset : 304 sectors
>    Super Offset : 0 sectors
> Recovery Offset : 2441891840 sectors
>           State : clean
>     Device UUID : eee3ae0e:f594fdba:58e19113:bc196464
>=20
>     Update Time : Mon Jan  5 00:30:41 2015
>        Checksum : 7a5a498d - correct
>          Events : 42912
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>    Device Role : Active device 4
>    Array State : A.AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

Note that the data offset is 304.  Some of your devices reported a data
offset of 264.  None of the reports were from original undisturbed
devices, so we really don't know what offset is correct.  "mdadm --add"
will use that mdadm version's offset if it can.

I suggest you try to re-establish the distro you used at the time (Apri=
l
2011) in a VM and create some test arrays with its version of mdadm to
get the offset to try first.

You then need to create a script that will perform the necessary "mdadm
--create --assume-clean" operations, followed by an "fsck -n" of the
device each time to see how messed up it is.  Each attempt into its own
log file, so you can see (by size) which attempts were "cleanest".
Inspect the "best" log files manually to see what was found.  With 40k
permutations, you may need to work out some grepping that will help
identify bad from possibly good.

If none of them come up relatively clean, try again with your next best
guess on the offset.

Good luck!

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
