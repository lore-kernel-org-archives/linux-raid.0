From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAobW9yZSBxdWVzdGlvbnMp?=
Date: Sun, 14 Jun 2009 01:10:00 -0600
Message-ID: <200906140710.n5E7A5o7074412@cjb.net>
References: <200906132027.n5DKRquL067127@cjb.net>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906132027.n5DKRquL067127@cjb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So here I was thinking everything was fine.  My six disks were working
for hours and the other two disks were loaded as spares and the first
one was rebuilding, up to 30% with an ETA of 5 hours.  I left the house
for a few hours and when I came back, the same disk with read errors
before had spontaneously disconnected and reconnected three times (I
saw in dmesg).  It probably got around 80% of the way through the six
hour rebuild.

The problem is that when the /dev/sdc disk reconnected itself after,
it was marked as a "Spare", and now I can't use the same command any
longer:

# mdadm --assemble /dev/md13 --verbose --force /dev/sd{a,b,c,d,e,f}1

This time it doesn't work, as it says 5 disks and 1 spare isn't enough
to start the array.  I also tried --re-add, but it already thinks it
is disk 9 out of 8, a Spare.

How can I safely put this disk back into its proper place so I can
again try to rebuild disks 7 and 8?  I'm assuming I probably need to
use mdadm --create, but I'm not sure, and don't want to get it wrong
and have it overwrite this needed disk.

 - S.A.





