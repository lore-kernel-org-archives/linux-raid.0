From: Robert L Mathews <lists@tigertech.com>
Subject: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Sun, 30 Mar 2008 16:22:46 -0700
Message-ID: <47F020C6.1060809@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using a two-disk SATA RAID 1 array on a number of identical servers, 
currently running kernel 2.6.8 (I know that's outdated; we use security 
backports and will soon be upgrading to 2.6.18).

Over the last year, a disk has failed on three different servers (with 
different brands of disks).

What I'd hope to happen in such situations is that the bad disk would be 
dropped from the RAID array automatically, and the machine would 
continue running with a degraded array.

However, in all three cases, that's not what happened. Instead, 
something like the following is printed to dmesg:

  ata2: command 0x35 timeout, stat 0xd0 host_stat 0x20
  scsi1: ERROR on channel 0, id 0, lun 0, CDB: Write (10) 00 07 b2 c7 80 
00 00 10 00
  Current sdb: sense key Medium Error
  Additional sense: Write error - auto reallocation failed
  end_request: I/O error, dev sdb, sector 129156992
  ATA: abnormal status 0xD0 on port 0xE407

Once this happens, all disk reads and writes fail to complete. "top" and 
"ps" show many processes stuck in the "D" state, from which they never 
recover. Using "kill -9" on them has no effect.

If I run a new program that requires disk access, that program hangs the 
terminal and can't be killed.

Using "iostat" shows no reads or writes occurring either at the md layer 
or on the underlying /dev/sda and /dev/sdb devices, although the "%util" 
column, oddly, shows 100% usage for the failed disk.

Running any mdadm command doesn't work. I don't see anything on the 
screen and that terminal hangs, presumably because mdadm tries doing 
disk access and gets hung in the "D" state, too.

I've waited several minutes to see if the machine will recover, and it 
doesn't. I eventually have to power cycle it.

Shouldn't the write error cause the bad disk to be gracefully removed 
from the array? Is this something that's likely to work better when we 
upgrade to a newer kernel version?

-- 
Robert L Mathews

  "In the beginning, the universe was created. This has made a lot of
   people very angry and has been widely regarded as a bad move."
                                                    -- Douglas Adams
