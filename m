From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RAID-6 development snapshot (not quite working yet)
Date: 21 Dec 2003 00:35:07 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bs3lvr$8dt$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've finally been able to shake loose enough time (or more like it, I
needed a project or I'd go insane) to get my RAID-6 project
relaunched.  I now have a development snapshot against linux-2.6.0 and
mdadm-1.4.0 available at:

ftp://ftp.kernel.org/pub/linux/kernel/people/hpa/raid6-20031220-dontuse.tar.gz

This release is "dontuse" because there is some kind of problem with
I/O scheduling in degraded mode (both 1- and 2-degraded mode.)  As a
result, raid6d eventually goes into an infinite loop.

However, the data is definitely there -- I can create a filesystem on
a raid, and it will still fsck clean after gunning two disks.  I
suspect that there is some corner case in the RAID-5 code which I
haven't understood properly and just blindly copied over, which just
doesn't work quite right for RAID-6.

Eyeballs on the code is of course appreciated.  Unfortunately I have
to move house next month, so I'm not sure how much longer I'm going to
be able to have a working test setup :) On the other hand, I think the
code is getting pretty close to actually working :)

Special thanks to Penguin Computing for donating a RAID test system
with enough drives to make meaningful RAID-6 testing possible.

	-hpa



-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
