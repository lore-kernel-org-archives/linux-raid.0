From: Jason Pfingstmann <stclists@wearesimply.com>
Subject: Raid 5 and Power Failure
Date: Fri, 12 Jul 2002 16:22:59 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200207121622.59345.stclists@wearesimply.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

This is my first post to this mailing list...I subscribed because of this 
issue I'm having and need help....

First off, let me explain what I have (had) in place..

An Intel 440GX server board with 2 processors and onboard LVD SCSI (aic7xxx).  
A Promise UDMA controller (PDC20267 - don't remeber which model exactly, but 
that is the driver the kernel uses for it)
7 IDE drives (Maxtor 4D080H4 x 3; Seagate ST380021A; Maxtor 98196H8; WDC 
WD800BB-32BSA0; WDC WD800AB-22BTA0)
3 SCSI Drives (IBM and Seagate)

I initially set up the system with a SuSE 7.3 install - 2.4.10 and have since 
compiled a custom kernel @ 2.4.18

I have the 7 drives configured in Raid 5 with no spares for about 400 GB of 
storage (they are all 80 GB drives)

There is an APC UPS (400VA capacity) connected to the system.

The server was running fine until last night when it froze without response 
from pings or physically at the console...I hit the reset button to bring it 
back up...

Now, the event counter for the raid 5 array lists 3 different things - 5 
drives show event counter to be 00 00 00 38, 1 drive shows 00 00 00 28 (hda), 
and 1 drive shows 00 00 00 37 (hdd).

md says hdg1 is freshest and kicks "non-fresh hda1 from array"..it then says 
"kicking faulty hdd1" and "not enough operational devices for md0 (2/7 
failed)"

Even if hdd is completely bad, I can't afford to lose 250 GB of data...if hda1 
is out of sync, is there anyway to force it to accept it (with a few corrupt 
files maybe)...  I read that someone manually edited the event counter to 
allow it to think the drive is ok, I can't find the event counter when 
looking at the drive in hex (using Microscope Diagnostics to view drive)...I 
have no clue where on the drive to look.

Someone said that using mkraid --force is the way to go because you can force 
a new superblock, that is contingent on having /etc/raidtab up to date...it 
seems to be empty for me...don't know why or where it went...I tried to 
recreate it manually with a typical raid 5 configuration, it keeps telling me 
invalid chunk size when I do an mkraid --force --configfile /etc/raidtab 
/dev/md0  (I put in 128k and it thinks I mean 128MBl; I put just 128 and it 
does the same...looked at man pages and followed their example, same 
problem)...

Anyhow, the event counters are still the same as they were, so I don't think 
the mkraid actually wrote anything due to the errors.  I have 1 extra 80 GB 
drive that I can use to make a backup of an existing drive (I don't have 7 
though) -- it is a Maxtor tho, and the 2 failed drives are both Western 
Digitals....

Any ideas or suggestions?  Am I barking up the wrong proverbial tree?  Should 
I shoot the server and tell my anime group (this was the anime server that 
they contributed funds to to build) of this catastrophe and risk a lynching?  
Any help is appreciated...thanks in advance.

