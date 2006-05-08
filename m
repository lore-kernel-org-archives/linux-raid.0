From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Horrific Raid 5 crash... help!
Date: Mon, 8 May 2006 18:47:06 +0200
Message-ID: <62b0912f0605080947n42e1e40blfe29b2360573cff1@mail.gmail.com>
References: <004b01c67248$d0e9e8c0$a300a8c0@enterprise.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <004b01c67248$d0e9e8c0$a300a8c0@enterprise.local>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:
> Well today, during this illustrious rebuild... it appears I actually DID
> have a disk fail. So, I have 26 disks... 1 partially rebuilt, and 1 failed.

Common scenario it seems.

> Hoping and praying that a rebuild didn't actually wipe the disk and maybe
> just synced things up -- I did a create with the 26 disks + 1 partially
> rebuilt and 1 'missing disk'....

I've always loathed that approach.
It seems *so* wrong to force MD to nuke all the information that is in
the superblocks.

I know this is the recommended approach, and I wish it would be changed.
Better sooner than later, too :-).

> well, the array came up.... but I get access denied on a zillion things,
> and the filesystem is freaking out.

Do you have something like mdadm's printout of the superblocks before
and after you did the "mdadm --create"?  Without that information,
it's going to be hard to tell what's going on.

My best guess is that you've assembled the array using the halfway
rebuilt disk, that it was kicked by MD long ago on basis of a single
bad block somewhere, and that the disk happens to contain a bunch of
old data which confuses the filesystem.

But it's a *very* wild guess.

> Before I proceed any further... what are my options? Do I have any options?

Hard to say unless you can tell us which disks failed, and when, and
which disks you use to assemble now, etc etc.

The more information, the better.

> I could run a fsck... but I held off fearing it could just make things worse.

Good thinking..
I've often seen ext3 fsck do a lot more harm than good.
(I believe reiser's fsck is pretty good, but haven't got any
experience with it.)
Until you're sure you've got everything right, I wouldn't run fsck.

In fact, assemble the array readonly and mount the filesystem readonly.

If you need to do modifications, and you're not sure you're doing it
right, you can make a duplicate of the individual disks in the RAID
and perform experiments on those.  Of course, the price tag depends on
how many GB your array is..
