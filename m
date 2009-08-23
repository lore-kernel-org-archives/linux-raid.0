From: Tony Arcieri <tony@medioh.com>
Subject: md tries to assemble md_d0 instead of md0
Date: Sun, 23 Aug 2009 10:12:43 -0600
Message-ID: <c7e6b2b00908230912w59f1998wd109272b6904e03b@mail.gmail.com>
References: <c7e6b2b00908230907v4a02a76bt9641e8dca009d64e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c7e6b2b00908230907v4a02a76bt9641e8dca009d64e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a fileserver with a 5 disk RAID-5.=A0 Things were going along
swimmingly with it for about a year, until one day it rebooted (I
assume because of a power blip/outage).

md0 was never assembled.=A0 Instead, it tried to assemble md_d0.

I have no idea what md_d0 is.=A0 I never tried to create md_d0.=A0 I do=
n't
even know what md_d0 is supposed to represent.

Upon boot, md would add one *random* drive to md_d0.=A0 This means
different drive letters, different drive contents, no rhyme or reason
to the whole thing.=A0 It would literally pick one out of the 5 disks i=
n
my array and add it to md_d0.=A0 I am not joking when I say it's a
different disk every time.=A0 It is, and only one disk.=A0 It would not
bother to try to assemble md0 at all.=A0 It just tosses one and only on=
e
random drive into md_d0:

[=A0=A0 77.968028] md: bind<sdc1>

I have verified it's a different disk every time by md5sum of the
first kilobyte on each disk.=A0 Every time I reboot it is a different
drive with a different drive letter.

mdstat looks like this:

--snip--
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md_d0 : inactive sdc1[1](S)
=A0=A0=A0=A0=A0 976759936 blocks

unused devices: <none>
--snip--

In the past I fixed this by stopping md_d0, removing the offending
drive from it, assembling md0, and adding the offending drive from
md_d0 back to the array (after zeroing its superblock with mdadm
--zero-superblock).=A0 This would result in a RAID resync, but after
that completed all was well.=A0 My fileserver was up for about a month
after performing this procedure without problems.

This morning I woke up and my clock was blinking, so I had a bit of a
power blip at my place.=A0 My fileserver had rebooted, and I find it
again in the exact same state: no attempts to assemble md0, and one
random drive added to md_d0.

Is there a permanent solution to this problem?=A0 Where is md_d0 even
coming from?=A0 How do I permanently get rid of it?

--
Tony Arcieri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
