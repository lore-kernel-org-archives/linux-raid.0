From: Technomage <technomage-hawke@cox.net>
Subject: Re: addendum: was Re: recovering data on a failed raid-0 installation
Date: Sat, 1 Apr 2006 01:23:51 -0700
Message-ID: <200604010123.52160.technomage-hawke@cox.net>
References: <200603290526.k2T5Qmp14592@www.watkins-home.com> <200603312156.26176.technomage-hawke@cox.net> <442E0F36.2050606@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442E0F36.2050606@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 31 March 2006 22:27, Mike Hardy wrote:
> Well, honestly I'm not really sure. I've never done this as I only use
> the redundant raid levels, and when they're gone, things are a complete
> hash and there's no hope. In fact, with raid-0 (striping, right? not
> linear/append?) I believe you are in the same boat. Each large file will
> have half its contents on the disk that died. So really, there's very
> little hope.

ok. in one of the tests we did, it has proved to have  written in a linear 
fashion. so, at least 1 disk may have most of the data (with mdadm v. 1.6.0).

But this was not the version of mdadm that was in dispute (mdadm v.1.9.0-3). 
we have not been able to prove that the version of mdadm that is in dispute 
writes in a linear mode, but that is the consensus at this point. The issue 
here is how the yast installer for suse creates the array, which is what we 
cannot confirm at this point. 



>
> Anyway, I'll try to give you pointers to what I would try anyway, with
> as much detail as I can.
>
> First, you just need to get the raid device up. It sounds like you are
> actually already doing that, but who knows. If you have one drive but
> not the other, you could make a sparse file that is the same size as the
> disk you lost. I know this is possible, but haven't done it so you'll
> have to see for yourself - I think there are examples in linux-raid
> archives in reference to testing very large raid arrays. Loopback mount
> the file as a device (losetup is he command to use here) and now you
> have a "virtual" device of the same size as the drive you lost.

it appears from the errors as detailed to me, the raid array does come up, but 
as soon as xfs tries to check the array is when the trouble starts. The 
errors for this have been posted here in another thread. 

as for the last sentence above, when we tried something similar, we 
encountered superblock problems. additionally, no valid or verifiable 
secondary superblocks could be found on the test array given the conditions 
to mimic the original problem.

>
> Recreate the raid array using the drive you have, and the new "virtual"
> drive in place of the one you lost. It's probably best to do this with
> non-persistent superblocks and just generally as read-only as possible
> for data preservation on the drive you have.

one small problem in the suse yast installer, "persistant superblocks" is 
usually defaulted to on. and that was not changed in the original install. 

>
> So now you have a raid array.
>
> For the filesystem, well, I don't know. That's a mess. I assume it's
> possible to mount the filesystem with some degree of force (probably a
> literally -force argument) as well as read-only. You may need to point
> at a different superblock, who knows?

This is xfs, it has a pretty good reputation at maintaining and retrieving 
data. However, as stated above, secondary superblocks could not be found to 
enable this operation.

>
> You just want to get the filesystem to mount somehow, any way you need
> to, but hopefully in a read-only mode.
>
> I would not even attempt to fsck it.
>
> At this point, you have a mostly busted filesystem on a fairly broken
> raid setup, but it might be possible to pull some data out of it, who
> knows? You could pull what looks like data but is instead garbage to
> though - if you don't have md5sums of the files you get (if you get any)
> it'll be hard to tell without checking them all.
>
> Honestly, that's as much as I can think of.
>
> I know I'm just repeating myself when I say this, but raid is no
> replacement for backups. They have different purposes, and backups are
> no less necessary. I was sorry to hear you didn't have any, because that
> probably seals the coffin on your data.

let us hope not. we still have several other options to try, including a 
partially functional drive that we can "possibly" retrieve data off of.

there is also the possibility that this is related to a kernel bug (as stated 
in another thread recently) and that there may not actually be anything wrong 
with the drive at all. 

>
> That said, it sounded like you had already tried to fsck the filesystem
> on this thing, so you may have hashed the remaining drive. It's hard to
> say. Truly bleak though...

actually, we have done nothing to the original other that to duplicate it. 
same goes for the secondary drive, though there were some problems on the 
laptop in question. IOW, my friend is so paranoid about the data that he 
treats the drives with tender loving care (IOW no destructive tests have 
been, or will be, run on the originals). 

on another front, because of the aforementioned kernel bug with XFS and mdadm, 
what are your thoughts on using LVM?

