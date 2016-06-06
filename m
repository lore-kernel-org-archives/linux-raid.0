From: Marc MERLIN <marc@merlins.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Mon, 6 Jun 2016 10:41:13 -0700
Message-ID: <20160606174113.GI12382@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Howdy, I have a raid 5 where one drive reported this:
197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always -       29

So I did this:
myth:~# echo check > /sys/block/md5/md/sync_action
[173947.749761] md: data-check of RAID array md5
(...)
[370316.769230] md: md5: data-check done.

My understanding was that it was supposed to read every block of every
drive, and if some blocks were unreadable, use parity to rewrite them on
some fresh backup blocks.
If a block returned garbage instead, md5 cannot fix this not knowing which
block is wrong, but I'm assuming the check would have failed with an error.

However after the check is over, I still have 29 Current_Pending_Sector on
that drive.

Since raid check succeeded, I'm going to assume that the sectors were
readable and did not return garbage, or I'd have gotten a parity mismatch
error.
Should then assume that either
1) the smart counter/logic is wrong?
2) the pending sectors started returning correct data again, so linux md has
no idea those blocks are "weak" and I have no easy way to forcibly remap
them.
3) the bad blocks did get remapped somehow, but the smart counter did not get
reset due to a firmware bug
4) other

After 2 days of testing with badblocks, it seems that it's #2, and I'm
not sure if there is anything raid check could have done (probably not)

Since raid check didn't do the job I was hoping for, I ran this instead:
myth:~# badblocks -nsv /dev/sdg  
Checking for bad blocks in non-destructive read-write mode  
From block 0 to 3907018583  
Checking for bad blocks (non-destructive read-write test)
Testing with random pattern:  57.87% done, 22:24:15 elapsed. (0/0/0 errors))

And this worked:
197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always       -       0
strangely, I also have:
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0

I guess this means that my drive's auto reallocation logic is faulty and
that it will not re-allocate blocks that are weak, even after it was
able to read them.
Does that sound correct?


More drive details from before I ran badblocks  (not an SMR drive):
Device Model:     WDC WD40EFRX-68WT0N0
Serial Number:    WD-WCC4E0642444
LU WWN Device Id: 5 0014ee 2b437e9a6
Firmware Version: 80.00A80
User Capacity:    4,000,787,030,016 bytes [4.00 TB]

  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       1617
  3 Spin_Up_Time            0x0027   175   173   021    Pre-fail  Always       -       8250
  4 Start_Stop_Count        0x0032   094   094   000    Old_age   Always       -       6773
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   074   074   000    Old_age   Always       -       19092
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       158
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       91
193 Load_Cycle_Count        0x0032   182   182   000    Old_age   Always       -       54642
194 Temperature_Celsius     0x0022   121   103   000    Old_age   Always       -       31
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always       -       29
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   199   000    Old_age   Always       -       2
200 Multi_Zone_Error_Rate   0x0008   200   189   000    Old_age   Offline      -       0

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     19081         -
# 2  Short offline       Completed without error       00%     19057         -
# 3  Short offline       Completed without error       00%     19035         -
# 4  Short offline       Completed without error       00%     18984         -
# 5  Extended offline    Completed without error       00%     18974         -

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
