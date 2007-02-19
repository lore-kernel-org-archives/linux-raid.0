From: "Marc Marais" <marcm@liquid-nexus.net>
Subject: Re: mdadm --grow failed
Date: Mon, 19 Feb 2007 13:41:05 +0800
Message-ID: <20070219053902.M44109@liquid-nexus.net>
References: <20070217030514.M74974@liquid-nexus.net> <17878.49009.771973.884472@notabene.brown> <20070218091504.M97223@liquid-nexus.net> <17880.7869.963793.706096@notabene.brown> <20070218105242.M29958@liquid-nexus.net> <20070218115626.M47438@liquid-nexus.net> <Pine.LNX.4.64.0702180712340.9820@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702180712340.9820@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 18 Feb 2007 07:13:28 -0500 (EST), Justin Piszcz wrote
> On Sun, 18 Feb 2007, Marc Marais wrote:
> 
> > On Sun, 18 Feb 2007 20:39:09 +1100, Neil Brown wrote
> >> On Sunday February 18, marcm@liquid-nexus.net wrote:
> >>> Ok, I understand the risks which is why I did a full backup before doing
> >>> this. I have subsequently recreated the array and restored my data from
> >>> backup.
> >>
> >> Could you still please tell me exactly what kernel/mdadm version you
> >> were using?
> >>
> >> Thanks,
> >> NeilBrown
> >
> > 2.6.20 with the patch you supplied in response to the "md6_raid5 crash
> > email" I posted in linux-raid a few days ago. Just as background, I replaced
> > the failing drive and at the same time bought an additional drive in order
> > to increase the array size.
> >
> > mdadm -V = v2.6 - 21 December 2006. Compiled under Debian (stable).
> >
> > Also, I've just noticed another drive failure with the new array with a
> > similar error to what happened during the grow operation (although on a
> > different drive) - I wonder if I should post this to linux-ide?
> >
> > Feb 18 00:58:10 xerces kernel: ata4: command timeout
> > Feb 18 00:58:10 xerces kernel: ata4: no sense translation for status: 0x40
> > Feb 18 00:58:10 xerces kernel: ata4: translated ATA stat/err 0x40/00 to SCSI
> > SK/ASC/ASCQ 0xb/00/00
> > Feb 18 00:58:10 xerces kernel: ata4: status=0x40 { DriveReady }
> > Feb 18 00:58:10 xerces kernel: sd 4:0:0:0: SCSI error: return code =
> > 0x08000002
> > Feb 18 00:58:10 xerces kernel: sdd: Current [descriptor]: sense key: Aborted
> > Command
> > Feb 18 00:58:10 xerces kernel:     Additional sense: No additional sense
> > information
> > Feb 18 00:58:10 xerces kernel: Descriptor sense data with sense descriptors
> > (in hex):
> > Feb 18 00:58:10 xerces kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00
> > 00 00 00 00
> > Feb 18 00:58:10 xerces kernel:         00 00 00 00
> > Feb 18 00:58:10 xerces kernel: end_request: I/O error, dev sdd, sector
> > 35666775
> > Feb 18 00:58:10 xerces kernel: raid5: Disk failure on sdd1, disabling
> > device. Operation continuing on 3 devices
> >
> > Regards,
> > Marc
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Just out of curiosity:
> 
> Feb 18 00:58:10 xerces kernel: end_request: I/O error, dev sdd,
>  sector 35666775
> 
> Can you run:
> 
> smartctl -d ata -t short /dev/sdd
> wait 5 min
> smartctl -d ata -t long /dev/sdd
> wait 2-3 hr
> smartctl -d ata -a /dev/sdd
> 
> And then e-mail that output to the list?
> 
> Justin.

Ok here we go:

/dev/sdd:

smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen Home page is
http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD1600JB-00EVA0
Serial Number:    WD-WMAEK2751794
Firmware Version: 15.05R15
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Feb 19 14:38:16 2007 GMT-9
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION === SMART overall-health self-assessment
test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (5073) seconds.
Offline data collection
capabilities: 			 (0x79) SMART execute Offline immediate.
					No Auto Offline data collection support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					No General Purpose Logging support.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  67) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.

SMART Attributes Data Structure revision number: 16 Vendor Specific SMART
Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000b   200   200   051    Pre-fail  Always     
 -       0
  3 Spin_Up_Time            0x0007   148   144   021    Pre-fail  Always     
 -       3141
  4 Start_Stop_Count        0x0032   100   100   040    Old_age   Always     
 -       91
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always     
 -       0
  7 Seek_Error_Rate         0x000b   200   200   051    Pre-fail  Always     
 -       0
  9 Power_On_Hours          0x0032   094   094   000    Old_age   Always     
 -       5070
 10 Spin_Retry_Count        0x0013   100   253   051    Pre-fail  Always     
 -       0
 11 Calibration_Retry_Count 0x0013   100   253   051    Pre-fail  Always     
 -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always     
 -       90
194 Temperature_Celsius     0x0022   116   253   000    Old_age   Always     
 -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always     
 -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always     
 -       0
198 Offline_Uncorrectable   0x0012   200   200   000    Old_age   Always     
 -       0
199 UDMA_CRC_Error_Count    0x000a   200   253   000    Old_age   Always     
 -       0
200 Multi_Zone_Error_Rate   0x0009   200   155   051    Pre-fail  Offline    
 -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours) 
LBA_of_first_error
# 1  Short offline       Completed without error       00%       691         -
# 2  Extended offline    Completed without error       00%       686         -
# 3  Short offline       Completed without error       00%       685         -
# 4  Short offline       Completed without error       00%       620         -
# 5  Extended offline    Completed without error       00%       598         -
# 6  Short offline       Completed without error       00%       597         -
# 7  Short offline       Completed without error       00%       573         -
# 8  Short offline       Completed without error       00%       549         -
# 9  Short offline       Completed without error       00%       525         -
#10  Short offline       Completed without error       00%       501         -
#11  Short offline       Completed without error       00%       477         -
#12  Short offline       Completed without error       00%       453         -
#13  Short offline       Completed without error       00%       382         -
#14  Short offline       Completed without error       00%       358         -
#15  Short offline       Completed without error       00%       334         -
#16  Short offline       Completed without error       00%       310         -
#17  Short offline       Completed without error       00%       286         -
#18  Extended offline    Completed without error       00%       264         -
#19  Short offline       Completed without error       00%       263         -
#20  Short offline       Completed without error       00%       239         -
#21  Short offline       Completed without error       00%       215         -

SMART Selective self-test log data structure revision number 1  SPAN  MIN_LBA
 MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

--
/dev/sdc:

smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen Home page is
http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD1600JB-00REA0
Serial Number:    WD-WCANM4681863
Firmware Version: 20.00K20
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Mon Feb 19 14:38:11 2007 GMT-9
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION === SMART overall-health self-assessment
test result: PASSED

General SMART Values:
Offline data collection status:  (0x85)	Offline data collection activity
					was aborted by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (4980) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  60) minutes.
Conveyance self-test routine
recommended polling time: 	 (   6) minutes.

SMART Attributes Data Structure revision number: 16 Vendor Specific SMART
Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always     
 -       0
  3 Spin_Up_Time            0x0003   184   184   021    Pre-fail  Always     
 -       3775
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always     
 -       19
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always     
 -       0
  7 Seek_Error_Rate         0x000f   200   200   051    Pre-fail  Always     
 -       0
  9 Power_On_Hours          0x0032   094   094   000    Old_age   Always     
 -       4834
 10 Spin_Retry_Count        0x0013   100   253   051    Pre-fail  Always     
 -       0
 11 Calibration_Retry_Count 0x0012   100   253   051    Old_age   Always     
 -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always     
 -       18
194 Temperature_Celsius     0x0022   114   095   000    Old_age   Always     
 -       33
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always     
 -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always     
 -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline    
 -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always     
 -       0
200 Multi_Zone_Error_Rate   0x0009   200   200   051    Pre-fail  Offline    
 -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours) 
LBA_of_first_error
# 1  Short offline       Completed without error       00%      4823         -
# 2  Extended offline    Completed without error       00%      4819         -
# 3  Short offline       Completed without error       00%      4817         -
# 4  Short offline       Completed without error       00%      4799         -
# 5  Short offline       Completed without error       00%      4775         -
# 6  Short offline       Completed without error       00%      4751         -
# 7  Extended offline    Completed without error       00%      4728         -
# 8  Short offline       Completed without error       00%      4727         -
# 9  Short offline       Completed without error       00%      4703         -
#10  Short offline       Completed without error       00%      4679         -
#11  Short offline       Completed without error       00%      4655         -
#12  Short offline       Completed without error       00%      4631         -
#13  Short offline       Completed without error       00%      4607         -
#14  Short offline       Completed without error       00%      4583         -
#15  Short offline       Completed without error       00%      4511         -
#16  Short offline       Completed without error       00%      4487         -
#17  Short offline       Completed without error       00%      4463         -
#18  Short offline       Completed without error       00%      4439         -
#19  Short offline       Completed without error       00%      4415         -
#20  Extended offline    Completed without error       00%      4393         -
#21  Short offline       Completed without error       00%      4391         -

SMART Selective self-test log data structure revision number 1  SPAN  MIN_LBA
 MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
