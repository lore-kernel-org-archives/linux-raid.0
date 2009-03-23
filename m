From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Questions about 1.X RAID metadata
Date: Tue, 24 Mar 2009 00:40:22 +0200
Message-ID: <20090324004022.510bd6b5@ktinos.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I would like to ask about the V1 RAID metadata.

I searched the mailing list archives for "metadata" and found some interesting
posts like the following:

"Time to deprecate old RAID formats"
"Superblock limits / conversion"
http://linux-raid.osdl.org/index.php/RAID_superblock_formats
http://linux-raid.osdl.org/index.php/Superblock

However i still have some questions as there is much confusion about V1 metadata.
I proceed with my questions:

1) The Superblock article from linux-raid.osdl.org (and some posts in the Time
to deprecate old RAID formats thread) mention that LILO can't boot of V1 metadata
The thread in the mailing list is dated October 2007 and the Superblock article
doesn't mention date, so I don't know if this still stands.

Also, http://lilo.go.dyndns.org/ doesn't work for me so i can't see if there is
any new LILO version. I use version 22.8

So, can LILO 22.8 (or a newer one if it exists) boot off V1 metadata ?

2) A setup that is usually recommended is to install LILO in the RAID partition
and mark that partition bootable. So the MBR will boot from the first partition
that is bootable which is the RAID one.

This obviously works for 0.90 and i assume it would work for 1.0 and 1.2
If someone chooses 1.1 metadata which are stored in the start of the device, he
can't install any bootloader to the RAID partition because it would overwrite
512 bytes of the RAID metadata.

Is this thought of mine correct ?
In other words can a bootloader (512 bytes - 1 sector) be installed in a
RAID partition using 1.1 metadata ? (Same question for 1.0 and 1.2)

3) I read in many posts in the mailing list archives about V1 metadata not
allowing "recovery to continue after restart".
Is this correct ? Or recovery continues from where it stopped like it does
with the 0.90 metadata ?

I apologize if my questions are already answered, but i couldn't find a
definitive (and up to date) answer.

Thank you for your time.
