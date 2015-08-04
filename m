From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID1 degraded
Date: Tue, 04 Aug 2015 14:33:34 +1000
Message-ID: <55C0409E.5010004@websitemanagers.com.au>
References: <AA2DC53A-A663-45CE-A8FE-DF6C8C285F37@me.com> <55BFFDD3.5000005@websitemanagers.com.au> <478DB4ED-9FAB-4035-A482-0BC11046B6C2@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <478DB4ED-9FAB-4035-A482-0BC11046B6C2@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Malissa <hmalissa@me.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/08/15 14:16, Hans Malissa wrote:
> Thanks a lot for your help!
> smartctl yields the following information (details see below): /dev/s=
db looks ok, but /dev/sdc seems to have quite a problem. /dev/sdc seems=
 nonexistent, it=92s not even in /dev/ anymore. The disk is physically =
present, but that=92s about it.
> The kernel logs contain a lot of information; what should I be lookin=
g for?

The logs should contain information on why or what happened when the=20
disk (sdc) vanished. In your case, it does indeed look like sdc has=20
failed, so you have a number of options depending on your preference:
1) Simply reboot (including a complete power off) the machine, and see=20
if sdc comes back. If it does, do some tests, and then add back to the=20
array. If it survives, then carry on as normal.

2) If you are more cautious (and more prepared to spend the money rathe=
r=20
than risk the data), then purchase a replacement disk, and replace sdc=20
with the new disk. Prepare the drive/partition, and add it to the raid=20
array.

Please make sure you "Research SCT/ERC on this list"!!! before=20
purchasing the replacement drive. It is far better to buy the right=20
drive if possible.

Regards,
Adam

> Thanks a lot,
>
> Hans
>
> # smartctl -a /dev/sdb
> smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.7.10-1.45-desktop] (SUS=
E RPM)
> Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontoo=
ls.org
>
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST1000DM003-1ER162
> Serial Number:    Z4Y6N2J3
> LU WWN Device Id: 5 000c50 07afe5c18
> Firmware Version: CC45
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
> Local Time is:    Mon Aug  3 21:52:32 2015 MDT
>
> =3D=3D> WARNING: A firmware update for this drive may be available,
> see the following Seagate web pages:
> http://knowledge.seagate.com/articles/en_US/FAQ/207931en
> http://knowledge.seagate.com/articles/en_US/FAQ/223651en
>
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection activ=
ity
>                                          was never started.
>                                          Auto Offline Data Collection=
: Disabled.
> Self-test execution status:      (   0) The previous self-test routin=
e completed
>                                          without error or no self-tes=
t has ever
>                                          been run.
> Total time to complete Offline
> data collection:                (   80) seconds.
> Offline data collection
> capabilities:                    (0x73) SMART execute Offline immedia=
te.
>                                          Auto Offline data collection=
 on/off support.
>                                          Suspend Offline collection u=
pon new
>                                          command.
>                                          No Offline surface scan supp=
orted.
>                                          Self-test supported.
>                                          Conveyance Self-test support=
ed.
>                                          Selective Self-test supporte=
d.
> SMART capabilities:            (0x0003) Saves SMART data before enter=
ing
>                                          power-saving mode.
>                                          Supports SMART auto save tim=
er.
> Error logging capability:        (0x01) Error logging supported.
>                                          General Purpose Logging supp=
orted.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 105) minutes.
> Conveyance self-test routine
> recommended polling time:        (   2) minutes.
> SCT capabilities:              (0x1085) SCT Status supported.
>
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPD=
ATED  WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x000f   111   100   006    Pre-fail  Al=
ways       -       39301104
>    3 Spin_Up_Time            0x0003   097   097   000    Pre-fail  Al=
ways       -       0
>    4 Start_Stop_Count        0x0032   100   100   020    Old_age   Al=
ways       -       20
>    5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Al=
ways       -       0
>    7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Al=
ways       -       2152462
>    9 Power_On_Hours          0x0032   098   098   000    Old_age   Al=
ways       -       1872
>   10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Al=
ways       -       0
>   12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Al=
ways       -       20
> 183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alw=
ays       -       0
> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Alw=
ays       -       0
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Alw=
ays       -       0
> 188 Command_Timeout         0x0032   100   100   000    Old_age   Alw=
ays       -       0 0 0
> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Alw=
ays       -       0
> 190 Airflow_Temperature_Cel 0x0022   068   064   045    Old_age   Alw=
ays       -       32 (Min/Max 26/35)
> 191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Alw=
ays       -       0
> 192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Alw=
ays       -       0
> 193 Load_Cycle_Count        0x0032   093   093   000    Old_age   Alw=
ays       -       15119
> 194 Temperature_Celsius     0x0022   032   040   000    Old_age   Alw=
ays       -       32 (0 19 0 0 0)
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alw=
ays       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Off=
line      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alw=
ays       -       0
> 240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Off=
line      -       662h+04m+56.474s
> 241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Off=
line      -       2212066311
> 242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Off=
line      -       4204083236
>
> SMART Error Log Version: 1
> No Errors Logged
>
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t=
]
>
>
> SMART Selective self-test log data structure revision number 1
>   SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>      1        0        0  Not_testing
>      2        0        0  Not_testing
>      3        0        0  Not_testing
>      4        0        0  Not_testing
>      5        0        0  Not_testing
> Selective self-test flags (0x0):
>    After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>
> # smartctl -a /dev/sdc
> smartctl 6.0 2012-10-10 r3643 [x86_64-linux-3.7.10-1.45-desktop] (SUS=
E RPM)
> Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontoo=
ls.org
>
> Smartctl open device: /dev/sdc failed: No such device
>
> On Aug 3, 2015, at 5:48 PM, Adam Goryachev <mailinglists@websitemanag=
ers.com.au> wrote:
>
>> On 04/08/15 08:18, Hans Malissa wrote:
>>> Hi everybody,
>>>
>>> It looks like one of my disks in my RAID1 just failed:
>>>
>>> [SNIP]
>>>
>>> Are there any other tests I could run in order to figure out what=92=
s going on? It looks like I will have to replace /dev/sdc1 with a new h=
ard drive. What is the correct procedure to do so without loosing my da=
ta?
>>>
>> Have a look at dmesg or your system kernel logs for details.
>> Also, use smartctl to examine what the drive itself thinks.
>> Also, try to use dd to read/write the drive.
>>
>> One common scenario is that you haven't configured the timing for th=
e drive correctly, and the drive is working perfectly, but didn't respo=
nd to the kernel quickly enough. Research SCT/ERC on this list
>>
>> Regards,
>> Adam
>> --=20
>> Adam Goryachev Website Managers www.websitemanagers.com.au


--=20
Adam Goryachev Website Managers www.websitemanagers.com.au
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
