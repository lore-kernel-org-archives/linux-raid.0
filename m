From: Paul Clements <clemep@steeleye.com>
Subject: Re: raid1 over lvm and nbd => recovery thread fails
Date: Sun, 7 Jul 2002 14:47:21 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10207071427540.7165-100000@clements.sc.steeleye.com>
References: <20020705105215.GK26595@martin.mh57.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020705105215.GK26595@martin.mh57.net>
To: Martin Hermanowski <martin@martin.mh57.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Jul 2002, Martin Hermanowski wrote:

> I've made a raid1 mirror of an lvm partition and an nbd from another
> machine. Then I created an ext3 fs on it. 

I've not tried this with LVM, but have done similar things with a SCSI disk
partition and nbd device under raid1. There are a few bugs in these
drivers that could lead to the scenario you describe below (recovery stuck
at 0% and never progressing). Which kernel are you using? Unfortunately,
I think just about every currently available Linux distribution kernel 
has these problems (save maybe the Red Hat Advanced Server 2.4.9 kernel). 
But the good news is that the problems should be fixed in 2.4.19, which 
will be available soon.

> This all works quite well, but after about 6~12 disconnects and
> reconnects of the nbd (disc-failures for the raid) while the recovery
> thread is working, the recovery thread is show as folling in
> /proc/mdstat:
> |     [>....................]  recovery =  0.0% (0/16777152)
> |     finish=461360.7min speed=0K/sec

I have seen this same symptom. It turns out that this is due to some bugs
in the raid1 driver. These problems were especially bad on SMP machines. 
So I'm fairly certain that you're running into the same problems that 
I discovered a few months ago. There are also some minor issues in the 
nbd driver that might be contributing to the problem.

I can give you some patches that will most likely fix these problems, if
you are willing/able to patch your kernel. Or, as I said, you can wait until
2.4.19 is available.

> Is there any way to stop the recovery thread manually?

No. Because of the locking that is performed in the raid1/md drivers, there
is no way to stop a device that is in the middle of recovery since it is
marked "busy".

--
Paul Clements
SteelEye Technology
Paul.Clements@SteelEye.com

