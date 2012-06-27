From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Wed, 27 Jun 2012 07:34:13 -0500
Message-ID: <4FEAFDC5.7030205@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>   <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>   <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>   <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>  <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>  <4FEA1A4F.9090605@hardwarefreak.com> <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/27/2012 4:07 AM, Ramon Hofer wrote:
> On Die, 2012-06-26 at 15:23 -0500, Stan Hoeppner wrote:
>> On 6/26/2012 3:37 AM, Ramon Hofer wrote:
>>
>>> Btw I ran the four dd commands within a screen session if this is of any
>>> importance?
>>
>> Can you get to that screen session?  Recall I showed you the output you
>> should have seen when each dd command completed?  Did you see four such
>> sets of output in the screen session?
> 
> I was able to get into the screen session but the output wasn't shown.
> It seemed as if all four commands were still running.
> top showed the dd commands as well but I'm not sure if each four were
> still running.

Ok that's strange.  Looks like they hung somehow if they're still
showing in top.  Go ahead and kill them.  After you kill em confirm they
exited (no longer it top).

>> Regardless, unless the dd commands hung in some way, they should not
>> show up in top right now.  So it's probably safe to assume they completed.
> 
> How long would it approximately take for the dd command to clear the
> drive?
> Can I assume a write rate of 100 MB/s?

It'll be 100-120 at the beginning, and slow to 20-30 as dd is writing
sectors on the inner platter tracks.

> With a disk size of 2 TB thid should take about 6 hours?

Yeah, something like that.

> I think I'll let it run again this evening so that it can complete until
> the next day.

Do them one at a time this time, starting with /dev/sdk.  Remember to
issue sync.  E.g.

~$ dd if=/dev/zero of=/dev/sdk bs=16384; sync

Try a smaller block size this time, 16KB instead of 1M.

Oh, Ramon, before you do any of this, change to the deadline elevator:

~$ echo deadline > /sys/block/sdk/queue/scheduler

Dangit, Ramon, I can't believe I forgot to tell you this when you
installed the 9240.  Debian, like most distros, defaults to the CFQ
elevator, which is good, I guess, for interactive desktop use.  But it
sucks like a Hoover with most server workloads.  So add this to your
kernel boot options in grub's menu.list, normally found in
/boot/grub/menu.lst:

elevator=deadline

That will enable deadline each time you boot.  So after you make the
change go ahead and reboot the system.  Then proceed with your dd commands.

>> So at this point you can try creating the RAID5 array again.  If the dd
>> command did what we wanted, /dev/sdk should have remapped the bad
>> sector, and you shouldn't get the error kicking that drive.  If you
>> still do, you may need to replace the drive.
> 
> I'm not sure if I didn't kille the dd command too early.
> Maybe it's better to let it run again. Maybe even each disk at once?
> Maybe this would already tell if a disk is faulty?

Yeah, do em one at a time this time.  It'll cause less load, and you
should still be able to watch movies etc while it runs.

-- 
Stan
