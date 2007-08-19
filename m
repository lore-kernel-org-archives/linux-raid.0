From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Sun, 19 Aug 2007 21:17:50 +1000
Message-ID: <18120.9950.578786.624453@notabene.brown>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
	<18118.46141.966406.577626@notabene.brown>
	<c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Greg Nicholson on Saturday August 18
Sender: linux-raid-owner@vger.kernel.org
To: Greg Nicholson <d0gz.net@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday August 18, d0gz.net@gmail.com wrote:
> 
> That looks to me like the first 2 gig is completely empty on the
> drive.  I really don't think it actually started to do anything.

The backup data is near the end of the device.  If you look at the
last 2 gig you should see something.

> 
> Do you have further suggestions on where to go now?

Maybe an 'strace' of "mdadm -A ...." might show me something.

If you feel like following the code, Assemble (in Assemble.c) should
call Grow_restart.
This should look in /dev/sdb1 (which is already open in 'fdlist') by
calling 'load_super'.  It should then seek to 8 sectors before the
superblock (or close to there) and read a secondary superblock which
describes the backup data.
If this looks good, it seeks to where the backup data is (which is
towards the end of the device) and reads that.  It uses this to
restore the 'critical section', and then updates the superblock on all
devices.

As you aren't getting the messages 'restoring critical section',
something is going wrong before there.  It should fail:
  /dev/md0: Failed to restore critical section for reshape, sorry.
but I can see that there is a problem with the error return from
'Grow_restart'.  I'll get that fixed.


> 
> Oh, and thank you very much for your help.  Most of the data on this
> array I can stand to loose... It's not critical, but there are some of
> my photographs on this that my backup is out of date on.  I can
> destroy it all and start over, but really want to try to recover this
> if it's possible.  For that matter, if it didn't actually start
> rewriting the stripes, is there anyway to push it back down to 4 disks
> to recover ?

You could always just recreate the array:

 mdadm -C /dev/md0 -l5 -n4 -c256 --assume-clean /dev/sdf1 /dev/sde1  \
    /dev/sdd1 /dev/sdc1

and make sure the data looks good (which it should).

I'd still like to know that the problem is though....

Thanks,
NeilBeon
