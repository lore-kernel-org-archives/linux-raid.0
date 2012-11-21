From: Kks Kbase <kks.kbase@yahoo.in>
Subject: Adaptec RAID with smartctl issue
Date: Wed, 21 Nov 2012 14:24:03 +0800 (SGT)
Message-ID: <1353479043.26614.YahooMailNeo@web190604.mail.sg3.yahoo.com>
Reply-To: Kks Kbase <kks.kbase@yahoo.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have servers with Adaptec Hardware raid cards.=20
When I checking the HDD health on smartctl getting proper output from=20
one of the server but it doesn't perform well on another server. Also=20
both the servers are same raid card model=A0=A0Adaptec 5805.

Here is the result that I got expected:

# smartctl -d sat --all /dev/sg4
smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model: =A0 =A0 ST31000364AS
Serial Number: =A0 =A09VPDBF40
=46irmware Version: JD4B
User Capacity: =A0 =A01,000,204,886,016 bytes
Device is: =A0 =A0 =A0 =A0Not in smartctl database [for details use: -P=
 showall]
ATA Version is: =A0 8
ATA Standard is: =A0ATA-8-ACS revision 4
Local Time is: =A0 =A0Sat Nov =A03 02:39:31 2012 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status: =A0(0x82) Offline data collection activ=
ity
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 was completed without error.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Auto Offline Data Collection: Enabled.
Self-test execution status: =A0 =A0 =A0( =A0 0) The previous self-test =
routine completed
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 without error or no self-test has ever
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 been run.
Total time to complete Offline
data collection: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ( 617) seconds.
Offline data collection
capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x7b) SMART execu=
te Offline immediate.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Auto Offline data collection on/off support.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Suspend Offline collection upon new
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 command.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Offline surface scan supported.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Self-test supported.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Conveyance Self-test supported.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Selective Self-test supported.
SMART capabilities: =A0 =A0 =A0 =A0 =A0 =A0(0x0003) Saves SMART data be=
fore entering
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 power-saving mode.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 Supports SMART auto save timer.
Error logging capability: =A0 =A0 =A0 =A0(0x01) Error logging supported=
=2E
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 General Purpose Logging supported.
Short self-test routine
recommended polling time: =A0 =A0 =A0 =A0( =A0 1) minutes.
Extended self-test routine
recommended polling time: =A0 =A0 =A0 =A0( 181) minutes.
Conveyance self-test routine
recommended polling time: =A0 =A0 =A0 =A0( =A0 2) minutes.
SCT capabilities: =A0 =A0 =A0 =A0 =A0 =A0 =A0(0x103f) SCT Status suppor=
ted.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 SCT Feature Control supported.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME =A0 =A0 =A0 =A0 =A0FLAG =A0 =A0 VALUE WORST THRESH T=
YPE =A0 =A0 =A0UPDATED =A0WHEN_FAILED RAW_VALUE
=A0 1 Raw_Read_Error_Rate =A0 =A0 0x000f =A0 119 =A0 099 =A0 006 =A0 =A0=
Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 212569658
=A0 3 Spin_Up_Time =A0 =A0 =A0 =A0 =A0 =A00x0003 =A0 100 =A0 100 =A0 00=
0 =A0 =A0Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 0
=A0 4 Start_Stop_Count =A0 =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 020 =A0=
 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 14
=A0 5 Reallocated_Sector_Ct =A0 0x0033 =A0 100 =A0 100 =A0 036 =A0 =A0P=
re-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 0
=A0 7 Seek_Error_Rate =A0 =A0 =A0 =A0 0x000f =A0 085 =A0 060 =A0 030 =A0=
 =A0Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 375127250
=A0 9 Power_On_Hours =A0 =A0 =A0 =A0 =A00x0032 =A0 090 =A0 090 =A0 000 =
=A0 =A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 8843
=A010 Spin_Retry_Count =A0 =A0 =A0 =A00x0013 =A0 100 =A0 100 =A0 097 =A0=
 =A0Pre-fail =A0Always =A0 =A0 =A0 - =A0 =A0 =A0 0
=A012 Power_Cycle_Count =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 020 =A0 =
=A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 14
183 Unknown_Attribute =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
184 Unknown_Attribute =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 099 =A0 =A0=
Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
187 Reported_Uncorrect =A0 =A0 =A00x0032 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
188 Unknown_Attribute =A0 =A0 =A0 0x0032 =A0 100 =A0 100 =A0 000 =A0 =A0=
Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
189 High_Fly_Writes =A0 =A0 =A0 =A0 0x003a =A0 100 =A0 100 =A0 000 =A0 =
=A0Old_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
190 Airflow_Temperature_Cel 0x0022 =A0 074 =A0 052 =A0 045 =A0 =A0Old_a=
ge =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 26 (Lifetime Min/Max 24/28)
194 Temperature_Celsius =A0 =A0 0x0022 =A0 026 =A0 048 =A0 000 =A0 =A0O=
ld_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 26 (0 18 0 0)
195 Hardware_ECC_Recovered =A00x001a =A0 036 =A0 020 =A0 000 =A0 =A0Old=
_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 212569658
197 Current_Pending_Sector =A00x0012 =A0 100 =A0 100 =A0 000 =A0 =A0Old=
_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
198 Offline_Uncorrectable =A0 0x0010 =A0 100 =A0 100 =A0 000 =A0 =A0Old=
_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 0
199 UDMA_CRC_Error_Count =A0 =A00x003e =A0 200 =A0 200 =A0 000 =A0 =A0O=
ld_age =A0 Always =A0 =A0 =A0 - =A0 =A0 =A0 0
240 Head_Flying_Hours =A0 =A0 =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 44079249367717
241 Unknown_Attribute =A0 =A0 =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 4148400059
242 Unknown_Attribute =A0 =A0 =A0 0x0000 =A0 100 =A0 253 =A0 000 =A0 =A0=
Old_age =A0 Offline =A0 =A0 =A0- =A0 =A0 =A0 4242662455

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged. =A0[To run self-tests, use: smartctl -t=
]


SMART Selective self-test log data structure revision number 1
=A0SPAN =A0MIN_LBA =A0MAX_LBA =A0CURRENT_TEST_STATUS
=A0 =A0 1 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
=A0 =A0 2 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
=A0 =A0 3 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
=A0 =A0 4 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
=A0 =A0 5 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0Not_testing
Selective self-test flags (0x0):
=A0 After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.





Here is the output from the server that doesn't perform well ,


# smartctl -d sat --all /dev/sg4
smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Br=
uce Allen
Home page is http://smartmontools.sourceforge.net/

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model: =A0 =A0 ST31000556AS
Serial Number: =A0 =A09VP4H6XY
=46irmware Version: AB49
User Capacity: =A0 =A01,000,204,886,016 bytes
Device is: =A0 =A0 =A0 =A0Not in smartctl database [for details use: -P=
 showall]
ATA Version is: =A0 8
ATA Standard is: =A0ATA-8-ACS revision 4
Local Time is: =A0 =A0Sat Nov =A03 02:40:49 2012 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

SMART Disabled. Use option -s with argument 'on' to enable it.


There is nothing display further with smartctl on this server.

Anyone know what is the reason why the smartctl is not working on one s=
erver with the same spec on another server?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
