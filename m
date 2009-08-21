From: jeffunit <jeff@jeffunit.com>
Subject: a problem with mdadm 2.6.9
Date: Thu, 20 Aug 2009 19:01:32 -0700
Message-ID: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a computer that was running mdadm with no problems.
Then the motherboard failed, while the array was in the process of rebuilding.
I replaced the motherboard with a new motherboard,
and I an trying to rebuild my raid array.

I am running mandriva 2009.1 spring (the latest). The kernel is 2.6.29.6
I have a 7 drive raid 5 array.
I said
mdadm --assemble /dev/md0 /dev/sd[bcdefgh]

I got the error
mdadm cannot open device: /dev/sdb device or resouce busy
mdadm device /dev/md0 has no superblock - assembly aborted

I then tried to make a degraded array
mdadm --assemble /dev/sd[cdefgh] --force
That seemed to work, and the array was degraded.

I decided to reboot to see if I could get /dev/sdb online.
I did, and it didn't help.

What can I do to recover my array?

thanks in advance,
jeff


