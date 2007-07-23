From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Need clarification on raid1 resync behavior with bitmap support
Date: Mon, 23 Jul 2007 08:47:31 -0400
Message-ID: <170fa0d20707230547y3accc5c9v14805fdb3637e9c0@mail.gmail.com>
References: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
	 <18084.22271.122052.80056@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18084.22271.122052.80056@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/23/07, Neil Brown <neilb@suse.de> wrote:
> On Saturday July 21, snitzer@gmail.com wrote:

> > Could you share the other situations where a bitmap-enabled raid1
> > _must_ perform a full recovery?
>
> When you add a new drive.  When you create a new bitmap.  I think that
> should be all.
>
> > - Correct me if I'm wrong, but one that comes to mind is when a server
> > reboots (after cleanly stopping a raid1 array that had a faulty
> > member) and then either:
> > 1) assembles the array with the previously faulty member now
> > available
> >
> > 2) assembles the array with the same faulty member missing.  The user
> > later re-adds the faulty member
> >
> > AFAIK both scenarios would bring about a full resync.
>
> Only if the drive is not recognised as the original member.
> Can you test this out and report a sequence of events that causes a
> full resync?

Sure, using an internal-bitmap-enabled raid1 with 2 loopback devices
on a stock 2.6.20.1 kernel, the following sequences result in a full
resync.  (FYI, I'm fairly certain I've seen this same behavior on
2.6.18 and 2.6.15 kernels too but would need to retest):

1)
mdadm /dev/md0 --manage --fail /dev/loop0
mdadm -S /dev/md0
mdadm --assemble /dev/md0 /dev/loop0 /dev/loop1
  mdadm: /dev/md0 has been started with 1 drive (out of 2).
  NOTE: kernel log says:  md: kicking non-fresh loop0 from array!
mdadm /dev/md0 --manage --re-add /dev/loop0

2)
mdadm /dev/md0 --manage --fail /dev/loop0
mdadm /dev/md0 --manage --remove /dev/loop0
mdadm -S /dev/md0
mdadm --assemble /dev/md0 /dev/loop0 /dev/loop1
  mdadm: /dev/md0 has been started with 1 drive (out of 2).
  NOTE: kernel log says:  md: kicking non-fresh loop0 from array!
mdadm /dev/md0 --manage --re-add /dev/loop0

Is stopping the MD (either with mdadm -S or a server reboot) tainting
that faulty member's ability to come back in using a quick
bitmap-based resync?

Mike
