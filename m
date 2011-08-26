From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Fri, 26 Aug 2011 16:14:44 -0700
Message-ID: <4E5828E4.2050307@vorgon.com>
References: <4E57FE4D.5080503@vorgon.com> <CADNH=7GgGzhLLqYc5kSC=bMN43MK=DE1TwP7gDAeDutHCoO2kA@mail.gmail.com> <4E581D7F.1080709@vorgon.com> <CADNH=7H9bi3cswmaFoLnYKvVxds47axrKHR7qSrLP-6yn4iKGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7H9bi3cswmaFoLnYKvVxds47axrKHR7qSrLP-6yn4iKGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 8/26/2011 3:45 PM, Mathias Bur=C3=A9n wrote:
> On 26 August 2011 23:26, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>> um, no, that was the email that mdadm sends I thought. And it says p=
roblem
>> is sdb in each case. Though I was wondering why each one said [U_] i=
nstead
>> of [_U]. Here is the smartctl for sda and below that will be for sdb
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> vorg@x64VDR:~$ sudo smartctl -a /dev/sda
>> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.34.20100610.1] (loc=
al
>> build)
>> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourcefor=
ge.net
>>
>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> Model Family:     Seagate Barracuda 7200.11
>> Device Model:     ST3500320AS
>> Serial Number:    9QM7M86S
>> LU WWN Device Id: 5 000c50 01059c636
>> Firmware Version: SD1A
>> User Capacity:    500,107,862,016 bytes [500 GB]
>> Sector Size:      512 bytes logical/physical
>> Device is:        In smartctl database [for details use: -P show]
>> ATA Version is:   8
>> ATA Standard is:  ATA-8-ACS revision 4
>> Local Time is:    Fri Aug 26 15:23:41 2011 MST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
>> SMART overall-health self-assessment test result: PASSED
>>
>> General SMART Values:
>> Offline data collection status:  (0x82) Offline data collection acti=
vity
>>                                         was completed without error.
>>                                         Auto Offline Data Collection=
:
>> Enabled.
>> Self-test execution status:      (   0) The previous self-test routi=
ne
>> completed
>>                                         without error or no self-tes=
t has
>> ever
>>                                         been run.
>> Total time to complete Offline
>> data collection:                (  650) seconds.
>> Offline data collection
>> capabilities:                    (0x7b) SMART execute Offline immedi=
ate.
>>                                         Auto Offline data collection=
 on/off
>> support.
>>                                         Suspend Offline collection u=
pon new
>>                                         command.
>>                                         Offline surface scan support=
ed.
>>                                         Self-test supported.
>>                                         Conveyance Self-test support=
ed.
>>                                         Selective Self-test supporte=
d.
>> SMART capabilities:            (0x0003) Saves SMART data before ente=
ring
>>                                         power-saving mode.
>>                                         Supports SMART auto save tim=
er.
>> Error logging capability:        (0x01) Error logging supported.
>>                                         General Purpose Logging supp=
orted.
>> Short self-test routine
>> recommended polling time:        (   1) minutes.
>> Extended self-test routine
>> recommended polling time:        ( 119) minutes.
>> Conveyance self-test routine
>> recommended polling time:        (   2) minutes.
>> SCT capabilities:              (0x103b) SCT Status supported.
>>                                         SCT Error Recovery Control s=
upported.
>>                                         SCT Feature Control supporte=
d.
>>                                         SCT Data Table supported.
>>
>> SMART Attributes Data Structure revision number: 10
>> Vendor Specific SMART Attributes with Thresholds:
>> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED
>>   WHEN_FAILED RAW_VALUE
>>   1 Raw_Read_Error_Rate     0x000f   114   100   006    Pre-fail Alw=
ays
>> -       83309768
>>   3 Spin_Up_Time            0x0003   094   094   000    Pre-fail Alw=
ays
>> -       0
>>   4 Start_Stop_Count        0x0032   100   100   020    Old_age Alwa=
ys
>> -       13
>>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail Alw=
ays
>> -       0
>>   7 Seek_Error_Rate         0x000f   071   060   030    Pre-fail Alw=
ays
>> -       13556066
>>   9 Power_On_Hours          0x0032   094   094   000    Old_age Alwa=
ys
>> -       5406
>>   10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail Al=
ways
>>    -       0
>>   12 Power_Cycle_Count       0x0032   100   100   020    Old_age Alw=
ays
>> -       13
>> 184 End-to-End_Error        0x0032   100   100   099    Old_age   Al=
ways
>>    -       0
>> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Al=
ways
>>    -       0
>> 188 Command_Timeout         0x0032   100   100   000    Old_age   Al=
ways
>>    -       0
>> 189 High_Fly_Writes         0x003a   100   100   000    Old_age   Al=
ways
>>    -       0
>> 190 Airflow_Temperature_Cel 0x0022   067   065   045    Old_age   Al=
ways
>>    -       33 (Min/Max 30/35)
>> 194 Temperature_Celsius     0x0022   033   040   000    Old_age   Al=
ways
>>    -       33 (0 21 0 0)
>> 195 Hardware_ECC_Recovered  0x001a   058   033   000    Old_age   Al=
ways
>>    -       83309768
>> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Al=
ways
>>    -       0
>> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age Offl=
ine
>>   -       0
>> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Al=
ways
>>    -       0
>>
>> SMART Error Log Version: 1
>> No Errors Logged
>>
>> SMART Self-test log structure revision number 1
>> No self-tests have been logged.  [To run self-tests, use: smartctl -=
t]
>>
>>
>> SMART Selective self-test log data structure revision number 1
>>   SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>>     1        0        0  Not_testing
>>     2        0        0  Not_testing
>>     3        0        0  Not_testing
>>     4        0        0  Not_testing
>>     5        0        0  Not_testing
>> Selective self-test flags (0x0):
>>   After scanning selected spans, do NOT read-scan remainder of disk.
>> If Selective self-test is pending on power-up, resume after 0 minute=
 delay
>> On 8/26/2011 2:25 PM, Mathias Bur=C3=A9n wrote:
>>>
>>> smartctl -a /dev/sda
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> vorg@x64VDR:~$ sudo smartctl -a /dev/sdb
>> smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.34.20100610.1] (loc=
al
>> build)
>> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourcefor=
ge.net
>>
>> Vendor:               /1:0:0:0
>> Product:
>> User Capacity:        600,332,565,813,390,450 bytes [600 PB]
>> Logical block size:   774843950 bytes
>> scsiModePageOffset: response length too short, resp_len=3D47 offset=3D=
50
>> bd_len=3D46
>>>> Terminate command early due to bad response to IEC mode page
>> A mandatory SMART command failed: exiting. To continue, add one or m=
ore '-T
>> permissive' options.
>>
>
>
> Indeed, sorry. 600 PB... where did you get that drive? ;)
>
> /M

What about those pre-fail messages on the other drive? are they=20
something to worry about now?

Also, I ran the same thing on the 2 drives for md3 and got the same=20
pre-fail messages for both of those, plus one had this nice little note=
:

=3D=3D> WARNING: There are known problems with these drives,
AND THIS FIRMWARE VERSION IS AFFECTED,
see the following Seagate web pages:
http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=3D20=
7931
http://seagate.custkb.com/seagate/crm/selfservice/search.jsp?DocId=3D20=
7951

4 seagate drives in this computer, this will make 3 failures since I pu=
t=20
them in. I think the drives are still in warrenty. last time I replaced=
=20
one it was good till something like 2012 or 2013.  But any new drives=20
will be WD.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
