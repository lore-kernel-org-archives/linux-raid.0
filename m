From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: resync issue with raid 1 under 2.6.8
Date: Mon, 13 Sep 2004 14:06:53 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0C8098CA7F09CE419F0C2B68EB83587648B262@exchange.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi All,

I've noted some posts regarding resyncing issues with 2.6.6 so I thought
I'd forward this one on just in case.  Unfortunately I'm not able to
gather much hard info, so apologies if I'm too vague.


The problems started with a sector error on device (1) of a ATA raid 1
array (extfs3), apparently looping and stating something about md and
illegal sector on /dev/hdc2.  Unfortunately I wasn't there to witness
first hand and the error was not written down. (Just reboot the machine
and see if that fixes it!!!) 
Anyway an md resync ensured following the reboot, when 100% was reached
the system immediately switched to read-only, no syslog entries...  The
console was spewing out errors "md: error in start_transaction: Read
Only file system".  Had to forcibly reboot after 10 minutes waiting for
reboot to occur.  After an fsck and another reboot all is UU OK.  I've
been running raid on the machine for a couple of years, I've had two
drive failures in that time (raid worked perfectly without interuption)
and not had an issue til now following a relatively recent kernel
upgrade from 2.4.20 5 weeks ago to 2.6.7 and 2 weeks ago 2.6.8. 

Using ...  md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27 on Debian
unstable

Cheers,

Lewis 
