From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RAID-6 works!  (At least it seems to...)
Date: 23 Dec 2003 00:43:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bs8v7f$klr$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, at least I have a piece of code that passes my relatively simple
functionality tests.  Still, that's news, and this is the first RAID-6
snapshot that isn't *known* to be broken :)

I can at least mount filesystems, read and write data, reboot the
system and have the data still there, with 1 or 2 disks lost, and do a
reconstruction once the drives are added back in.

New development snapshot at:

ftp://ftp.kernel.org/pub/linux/kernel/people/hpa/raid6-20031224-experimental.tar.gz

Please test it out and let me know how badly it sucks :)

At some point I'll try to run some benchmarks.  There is also a lot of
optimization still to be done.

       -hpa

[And again, thanks to Penguin Computing for donating a test system,
without which this would never have happened.]
-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
If you send me mail in HTML format I will assume it's spam.
"Unix gives you enough rope to shoot yourself in the foot."
Architectures needed: ia64 m68k mips64 ppc ppc64 s390 s390x sh v850 x86-64
