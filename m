From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Wed, 13 Apr 2011 17:15:42 -0700 (PDT)
Message-ID: <541553.42147.qm@web65113.mail.ac2.yahoo.com>
References: <BANLkTinc-+cb-ZLJBr7m4283xf_MjZ2VmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinc-+cb-ZLJBr7m4283xf_MjZ2VmQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Thu, 14/4/11, Mathias Bur=E9n <mathias.buren@gmail.com> wrote:

> From: Mathias Bur=E9n <mathias.buren@gmail.com>
> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, s=
ystem unresponsive
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: neilb@suse.de, linux-raid@vger.kernel.org
> Date: Thursday, 14 April, 2011, 10:28
> On 13 April 2011 23:24, Gavin Flower
> <gavinflower@yahoo.com>
> wrote:
> >
> > --- On Fri, 8/4/11, Gavin Flower <gavinflower@yahoo.com>
> wrote:
> >
> >> From: Gavin Flower <gavinflower@yahoo.com>
> >> Subject: RAID6 data-check took almost 2 hours,
> clicking sounds, system unresponsive
> > [...]
> >> This morning, I noticed my system was extremely
> >> unresponsive, and that there were clicking sounds
> coming
> >> from one of my 5 hard drives.
> > [...]
> >
> > Hi Neil,
> >
> > When I do
> >   badblocks -s -v /dev/sdc
> > I hear clicking sounds from the hard drive, and notice
> lots and lots of log messages such as:
> > ata3: exception Emask 0x10 SAct 0x0 SErr 0x90200
> action 0xe frozen
> > ata3: irq_stat 0x00400000, PHY RDY changed
> > ata3: SError: { Persist PHYRdyChg 10B8B }
> > ata3: hard resetting link
> > ata3: softreset failed (device not ready)
> > ata3: applying SB600 PMP SRST workaround and retrying
> > ata3: SATA link up 1.5 Gbps (SStatus 113 SControl
> 310)
> > ata3.00: configured for UDMA/33
> > ata3: EH complete
> >
> > So I assume that the clicking corresponds to the hard
> reset, but I'm not certain of that.  Initially, I thought
> it might be some kind of disk head problems.  Note that
> smart reports no bad blocks.
> >
> >
> > Regards,
> > Gavin
> >
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> Perhaps you could post the full smartctl -a output?
>=20
> Regards,
> Mathias
>=20

Hi Mathias,

I was more commenting on the clicking sound, rather than asking for hel=
p!  However, I am happy to oblige, output follows later.

I am happy to provide additional diagnostics and log messages, should t=
hey be of use.


Regards,
Gavin

# smartctl -a /dev/sdc
smartctl 5.40 2010-10-16 r3189 [x86_64-redhat-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda 7200.12 family
Device Model:     ST3500418AS
Serial Number:    5VMJ3RJE
=46irmware Version: CC38
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Thu Apr 14 12:08:18 2011 NZST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activit=
y
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine =
completed
					without error or no self-test has ever=20
					been run.
Total time to complete Offline=20
data collection: 		 ( 600) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before enterin=
g
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine=20
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 (  85) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x103f)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   115   099   006    Pre-fail  Alway=
s       -       87918991
  3 Spin_Up_Time            0x0003   099   097   000    Pre-fail  Alway=
s       -       0
  4 Start_Stop_Count        0x0032   085   085   020    Old_age   Alway=
s       -       16014
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x000f   072   060   030    Pre-fail  Alway=
s       -       20251386
  9 Power_On_Hours          0x0032   097   097   000    Old_age   Alway=
s       -       2940
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   093   093   020    Old_age   Alway=
s       -       7999
183 Runtime_Bad_Block       0x0032   076   076   000    Old_age   Alway=
s       -       24
184 End-to-End_Error        0x0032   100   100   099    Old_age   Alway=
s       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Alway=
s       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age   Alway=
s       -       1
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Alway=
s       -       0
190 Airflow_Temperature_Cel 0x0022   067   055   045    Old_age   Alway=
s       -       33 (Min/Max 17/33)
194 Temperature_Celsius     0x0022   033   045   000    Old_age   Alway=
s       -       33 (0 16 0 0)
195 Hardware_ECC_Recovered  0x001a   031   026   000    Old_age   Alway=
s       -       87918991
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alway=
s       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offli=
ne      -       225696236445405
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offli=
ne      -       134453215
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offli=
ne      -       846601860

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
# 1  Short offline       Completed without error       00%         3   =
      -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

#=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
