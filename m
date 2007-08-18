From: "Greg Nicholson" <d0gz.net@gmail.com>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Sat, 18 Aug 2007 10:37:55 -0500
Message-ID: <c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
	 <18118.46141.966406.577626@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18118.46141.966406.577626@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/18/07, Neil Brown <neilb@suse.de> wrote:
> On Friday August 17, d0gz.net@gmail.com wrote:
> > I was trying to resize a Raid 5 array of 4 500G drives to 5.  Kernel
> > version 2.6.23-rc3 was the kernel I STARTED on this.
> >
> >   I added the device to the array :
> > mdadm --add /dev/md0 /dev/sdb1
> >
> > Then I started to grow the array :
> >  mdadm --grow /dev/md0 --raid-devices=5
> >
> > At this point the machine locked up.  Not good.
>
> No, not good.  But it shouldn't be fatal.

Well, that was my thought as well.
>
> >
> > I ended up having to hard reboot.  Now, I have the following in dmesg :
> >
> > md: md0: raid array is not clean -- starting background reconstruction
> > raid5: reshape_position too early for auto-recovery - aborting.
> > md: pers->run() failed ...
>
> Looks like you crashed during the 'critical' period.
>
> >
> > /proc/mdstat is :
> >
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : inactive sdf1[0] sdb1[4] sdc1[3] sdd1[2] sde1[1]
> >       2441918720 blocks super 0.91
> >
> > unused devices: <none>
> >
> >
> > It doesn't look like it actually DID anything besides update the raid
> > count to 5 from 4. (I think.)
> >
> > How do I do a manual recovery on this?
>
> Simply use mdadm to assemble the array:
>
>   mdadm -A /dev/md0 /dev/sd[bcdef]1
>
> It should notice that the kernel needs help, and will provide
> that help.
> Specifically, when you started the 'grow', mdadm copied the first few
> stripes into unused space in the new device.  When you re-assemble, it
> will copy those stripes back into the new layout, then let the kernel
> do the rest.
>
> Please let us know how it goes.
>
> NeilBrown
>


I had already tried to assemble it by hand, before I basically said...
WAIT.  Ask for help.  Don't screw up more. :)

But I tried again:


root@excimer {  }$ mdadm -A /dev/md0 /dev/sd[bcdef]1
mdadm: device /dev/md0 already active - cannot assemble it
root@excimer { ~ }$ mdadm -S /dev/md0
mdadm: stopped /dev/md0
root@excimer { ~ }$ mdadm -A /dev/md0 /dev/sd[bcdef]1
mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument


Dmesg shows:

md: md0 stopped.
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sde1>
md: export_rdev(sde1)
md: md0 stopped.
md: bind<sde1>
md: bind<sdd1>
md: bind<sdc1>
md: bind<sdb1>
md: bind<sdf1>
md: md0: raid array is not clean -- starting background reconstruction
raid5: reshape_position too early for auto-recovery - aborting.
md: pers->run() failed ...
md: md0 stopped.
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sde1>
md: export_rdev(sde1)
md: md0 stopped.
md: bind<sde1>
md: bind<sdd1>
md: bind<sdc1>
md: bind<sdb1>
md: bind<sdf1>
md: md0: raid array is not clean -- starting background reconstruction
raid5: reshape_position too early for auto-recovery - aborting.
md: pers->run() failed ...

And the raid stays in an inactive state.

Using mdadm v2.6.2 and kernel 2.6.23-rc3, although I can push back to
earlier versions easily if it would help.

I know that sdb1 is the new device.  When mdadm ran, it said the
critical section was 3920k (approximately).  When I didn't get a
response for five minutes, and there wasn't ANY disk activity, I
booted the box.

Based on your message and the man page, it sounds like mdadm should
have placed something on sdb1.  So... Trying to be non-destructive,
but still gather information:

 dd if=/dev/sdb1 of=/tmp/test bs=1024k count=1000
 hexdump /tmp/test
 0000000 0000 0000 0000 0000 0000 0000 0000 0000
 *
 3e800000

dd if=/dev/sdb1 of=/tmp/test bs=1024k count=1000 skip=999
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 35.0176 seconds, 29.9 MB/s
root@excimer { ~ }$ hexdump /tmp/test
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
3e800000

That looks to me like the first 2 gig is completely empty on the
drive.  I really don't think it actually started to do anything.

Do you have further suggestions on where to go now?

Oh, and thank you very much for your help.  Most of the data on this
array I can stand to loose... It's not critical, but there are some of
my photographs on this that my backup is out of date on.  I can
destroy it all and start over, but really want to try to recover this
if it's possible.  For that matter, if it didn't actually start
rewriting the stripes, is there anyway to push it back down to 4 disks
to recover ?
