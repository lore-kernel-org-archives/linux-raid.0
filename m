From: "harry" <hfranklin97@excite.com>
Subject: RE: disk testing
Date: Tue, 14 Sep 2004 05:04:31 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040914090431.1D6163965@xprdmailfe9.nwk.excite.com>
Reply-To: hfranklin97@excite.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It occurs to me that I should include the errors that were in dmesg:

raid5: switching cache buffer size, 1024 --> 4096
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on md(9,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
scsi0: ERROR on channel 0, id 0, lun 0, CDB: Request Sense 00 00 00 40 00 
Current sd0b:00: sense key Medium Error
Additional sense indicates Unrecovered read error
 I/O error: dev 0b:00, sector 7985264
scsi1: ERROR on channel 0, id 0, lun 0, CDB: Read (10) 00 0b 01 8c 2f 00 00 c8 00 
Current sd08:01: sense key Medium Error
Additional sense indicates Unrecovered read error - auto reallocate failed
 I/O error: dev 08:01, sector 184650736
raid5: Disk failure on sda1, disabling device. Operation continuing on 2 devices
raid5: parity resync was not fully finished, restarting next time.
md: recovery thread got woken up ...
md: updating md1 RAID superblock on device
md: sdc1 [events: 00000004]<6>(write) sdc1's sb offset: 244195904
md: sdb1 [events: 00000004]<6>(write) sdb1's sb offset: 244195904
md: (skipping faulty sda1 )
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: md_do_sync() got signal ... exiting
raid5: resync aborted!

Thanks, Harry

 --- On Tue 09/14, harry < hfranklin97@excite.com > wrote:
From: harry [mailto: hfranklin97@excite.com]
To: linux-raid@vger.kernel.org
Date: Tue, 14 Sep 2004 04:50:07 -0400 (EDT)
Subject: disk testing

<br>I just bought 3 sata drives and set them up in a raid5 array. About 45% into syncing them, the first disk gets an error and goes offline. I figure I did something wrong, so I retrace my steps and try again, and again, I get an error about 45% of the way through, the first disk errors and goes offline. <br><br>So, I think I have a bad disk. But wait! I created a raid 1 array on the remaining two to see if there are any other errors later on those two (there weren't), and I create a normal partition/fs on the failing disk. I begin writing various bitpatterns across the entire disk and reading them back, trying to find the problem. So far, I've done about 5 passes over the entire disk without error! <br><br>So, any idea why raid would be getting errors from the disk, but I don't seem to be able to? (or, what I should tell the store I bought it from when I try to get it replaced?)<br><br
 >Thanks, Harry<br><br>ps, The only thing I can think of is that the first time through I h
 ad been using the array (created a partition, started moving files onto it), and the excessive thrashing of the heads caused an intermittent error to show itself, whereas the tests I'm currently running are strictly linear and easy enough on the disk that the problem doesn't appear. 

_______________________________________________
Join Excite! - http://www.excite.com
The most personalized portal on the Web!
