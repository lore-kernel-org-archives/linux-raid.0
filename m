From: Maarten v d Berg <maarten@vbvb.nl>
Subject: Re: Extend raid 5
Date: Mon, 12 Jan 2004 11:52:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401121152.02791.maarten@vbvb.nl>
References: <1704458665.20040112011155@gmx.de> <200401121021.08498.maarten@vbvb.nl> <400270C2.3030009@smartjog.com>
Reply-To: maarten@nebula.vbvb.nl
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400270C2.3030009@smartjog.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 12 January 2004 11:02, Marc Bevand wrote:
> Maarten v d Berg wrote:
> > [...]

> > Otherwise, adding a 40 GB physical volume to a 120 GB raid5 / LVM set
> > just gives me one 120 GB partition and [room for] another 40 GB
> > partition. There is NO gain whatsoever using LVM here compared to when I
> > would just have added a single 40GB disk all by itself without using LVM
> > in the first place, is there ?
> >
> > This has always left me wondering.  Did I miss something (except using
> > some alpha FS-resize code...) ?
>
> This is precisely the point, you have to resize your filesystem so that
> the extra space added to your LVM device is used. There are many
> options, you can either use a userland tool (resize2fs, resize_reiserfs,
> ...) for resizing an *unmounted* filesystem, or you can do it in the
> kernel (mount -o remount,resize=<size> <device>). As you can see, doing
> it in the kernel has the extra advantage of allowing you to resize a
> *mounted* filesystem.

My raid filesystem is not part of the normal linux FS tree, so for me it is 
perfectly okay to umount the system.  I tend to only use reiserfs.

> Filesystem resizing is more stable than you think, for example the
> commercial program Partition Magic is based on resize2fs (but I am not
> sure if I can convince you with this example since proprietary software
> is evil :P).

I know partition magic but at the time I tried it it did not understand 
reiserfs so I dropped it. I don't know what the current version can do.

In any case I didn't want to run the risk at the time; I had something which 
could be called a "backup" (with some imagination) but it consisted of 
several tapes, disks and whatnot that could help restoring in case of a 
disaster but it was by no means near anything complete nor recent.
In other words, restoring would have cost me at least a full weekend and would 
have cost me anything between 5 - 20% of my data. I can accept that kind of 
risk for statistic 'normal' disasters but not for experiments with a higher- 
than-normal risk of losing the entire filesystem. 

The problem with adding a non-redundant drive to an existing raid-based LVM 
persists however. By adding that one drive and extending the FS to include 
that you introduce a single point of failure. Bye bye raid-redundancy...

Greetings,
Maarten

