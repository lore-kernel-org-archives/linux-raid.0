From: Martin Hermanowski <martin@martin.mh57.net>
Subject: Re: raid1 over lvm and nbd => recovery thread fails
Date: Sun, 7 Jul 2002 23:07:45 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020707210745.GF15958@martin.mh57.net>
References: <20020705105215.GK26595@martin.mh57.net> <Pine.LNX.4.10.10207071427540.7165-100000@clements.sc.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.10.10207071427540.7165-100000@clements.sc.steeleye.com>
To: Paul Clements <clemep@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 07, 2002 at 02:47:21PM -0400, Paul Clements wrote:
> On Fri, 5 Jul 2002, Martin Hermanowski wrote:
> 
>> I've made a raid1 mirror of an lvm partition and an nbd from another
>> machine. Then I created an ext3 fs on it. 
> 
> I've not tried this with LVM, but have done similar things with a SCSI disk
> partition and nbd device under raid1. There are a few bugs in these
> drivers that could lead to the scenario you describe below (recovery stuck
> at 0% and never progressing). Which kernel are you using? Unfortunately,
> I think just about every currently available Linux distribution kernel 
> has these problems (save maybe the Red Hat Advanced Server 2.4.9 kernel). 
> But the good news is that the problems should be fixed in 2.4.19, which 
> will be available soon.

I'm using a vanilla 2.4.18.

>> This all works quite well, but after about 6~12 disconnects and
>> reconnects of the nbd (disc-failures for the raid) while the recovery
>> thread is working, the recovery thread is show as folling in
>> /proc/mdstat:
>> |     [>....................]  recovery =  0.0% (0/16777152)
>> |     finish=461360.7min speed=0K/sec
> 
> I have seen this same symptom. It turns out that this is due to some bugs
> in the raid1 driver. These problems were especially bad on SMP machines. 

This is a single-cpu system, I think this only happens if there is lot
of writing, I could'nt reproduce it without this.

> So I'm fairly certain that you're running into the same problems that 
> I discovered a few months ago. There are also some minor issues in the 
> nbd driver that might be contributing to the problem.
> 
> I can give you some patches that will most likely fix these problems, if
> you are willing/able to patch your kernel. Or, as I said, you can wait until
> 2.4.19 is available.

I surely would like to try this.

Thanks for your explanation.
I will post the results with your patches/with 2.4.19 when available.

>> Is there any way to stop the recovery thread manually?
> 
> No. Because of the locking that is performed in the raid1/md drivers, there
> is no way to stop a device that is in the middle of recovery since it is
> marked "busy".
> 
> --
> Paul Clements
> SteelEye Technology
> Paul.Clements@SteelEye.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
