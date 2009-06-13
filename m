From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAoc3VjY2VzcyEp?=
Date: Sat, 13 Jun 2009 14:27:47 -0600
Message-ID: <200906132027.n5DKRquL067127@cjb.net>
References: <200906131802.n5DI2Kj0065178@cjb.net>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906131802.n5DI2Kj0065178@cjb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Problem solved, thank you for your help.

I use a custom program for creating a hardened encryption key,
wherein I need to fill in a bunch of information, including two
repetition values.  These are used to cycle over the binary key
rehashing it N times.

Prior to this Ubuntu upgrade, it would generate the key in about
15 seconds, after the upgrade about 1 minute.  Because of this
slowness, I thought I had set the repetition values too high,
and ended up reverting to the repetitions I used on my previous
computer from a few years ago.

I had been Ctrl+C'ing out of my key generating program because
it had seemed broken.  I actually sat and waited for it today,
and it worked fine.  Phew!

The filesystem had been unmounted when I had the RAID issue, so
the data is intact.

I figured out why three of the disks had higher events after
the shutdown as well:

My disks go into standby mode fairly quickly when not in use,
and some of the disks take a long time to wake up (~10 seconds),
while others are much quicker (~4 seconds).  When Ubuntu was
shutting down the system, the 3 slower disks didn't get woken
up before the reboot finished, so they were slightly behind.

I also solved why my event count was in the millions, which is
because I was running this command for realtime monitoring:

# watch -n 1 'mdadm --verbose --verbose --detail --scan /dev/md13|tail -n 23'

This mdadm command would repeat every second, and it would
update the event count by 2 each time.  I hadn't realised that
this way of monitoring the disks would alter the array in any
way.

Now I'm off to rebuild the 2 missing disks, and then build a
new array on another computer for backups.

 - S.A.





