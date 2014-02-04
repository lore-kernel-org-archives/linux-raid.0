From: Bill <billstuff2001@sbcglobal.net>
Subject: raid5 replace ignored error?
Date: Tue, 04 Feb 2014 03:00:50 -0600
Message-ID: <52F0AC42.5080407@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I had something weird happen during a replace in a raid5 array on kernel 
3.10.28 -
it appears an error in writing to / communicating with the replacement 
disk was ignored.

I have this array:

md3 : active raid5 sda1[0] sdd1[3] sdb1[1] sdf1[4] sdc1[2]
       3900742144 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
       bitmap: 0/233 pages [0KB], 2048KB chunk

I tried replacing sdf1 with sde1.

     [106666.129833] md: recovery of RAID array md3
     [106666.129836] md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
     [106666.129837] md: using maximum available idle IO bandwidth (but 
not more than 200000 KB/sec) for recovery.
     [106666.129842] md: using 128k window, over a total of 975185536k.

1/2 hour later I got a flood of errors in dmesg:

     [108334.974861] ata5.00: exception Emask 0x10 SAct 0x7fffffff SErr 
0x480100 action 0x6 frozen
     [108334.974864] ata5.00: irq_stat 0x08000000, interface fatal error
     [108334.974866] ata5: SError: { UnrecovData 10B8B Handshk }
     [108334.974868] ata5.00: failed command: WRITE FPDMA QUEUED
     [108334.974872] ata5.00: cmd 61/00:00:10:97:9e/04:00:15:00:00/40 
tag 0 ncq 524288 out
     [108334.974872]          res 40/00:b0:10:f7:9e/00:00:15:00:00/40 
Emask 0x10 (ATA bus error)
     [108334.974873] ata5.00: status: { DRDY }
     .
     .(29 more of the same message)
     .
     [108344.976877] ata5: softreset failed (1st FIS failed)
     [108344.976883] ata5: hard resetting link
     [108349.874854] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
     [108349.901025] ata5.00: configured for UDMA/133
     [108349.901055] ata5: EH complete

There were no md error messages, the recovery continued, and finished a 
few hours later.

     [122443.805899] md: md3: recovery done.


Afterwards I did a QC check and found a mismatch in one file which I 
mapped to the area
being updated when this error was logged.

What should happen in this case?
Should the "replace" have failed or is there something else going on here?

Thanks,
Bill


