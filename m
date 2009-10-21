From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Thu, 22 Oct 2009 10:44:53 +1100
Message-ID: <19167.40181.250468.925659@notabene.brown>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
	<358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
	<20091019155322.65b4287f@zombie>
	<5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
	<c57ee40d9e6139de2993fb18934837c2.squirrel@neil.brown.name>
	<20091020103731.5dc611ff@zombie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy Martin on Tuesday October 20
Sender: linux-raid-owner@vger.kernel.org
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 20, gmsoft@tuxicoman.be wrote:
> 
> Hi Neil,
> 
> Here is the output I've got :
> 
> bleh mdadm # ./mdadm --assemble /dev/md0 /dev/sd[bdef]1 --backup-file
> backup  -v mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
> mdadm:/dev/md0 has an active reshape - checking if critical section
> needs to be restored mdadm: too-old timestamp on backup-metadata on
> backup mdadm: Failed to find backup of critical section

Ahhh... I wondered a bit about that as I was adding the fprintf there,
but it was along the lines of "this cannot happen", not "this is where
the bug might be" :-)

I see now what is happening.  I need to update the mtime every time I
write the backup metadata (of course!).  I never tripped on this
because I never let a reshape run for more than a few minutes.

I have checked in a patch which updated the mtime properly, so it
should now word for you.

Thanks for helping make mdadm even better!

NeilBrown



> mdadm: Failed to restore critical section for reshape, sorry.
> 
> The backup file is of course the one I've been using for the grow
> command.
> 
> The values I've got :
>  - info->array.utime : 1256026602
>  - bsb.mtime : 1256020033
> 
> My timezone is Europe/Brussels if that matters.
> 
> Removing this check makes the reshape continue and the array start
> correctly.
> 
> Let me know if you want me to do some more tests.
> 
> HTH,
>   Guy
> 
> 
> On Tue, 20 Oct 2009 16:54:43 +1100
> "NeilBrown" <neilb@suse.de> wrote:
> 
> > I tried to reproduce this and failed - it works perfectly for me.
> > 
> > I have added some more tracing messages to --assemble which are
> > enabled by --verbose.
> > Could you please pull the latest devel-3.1 branch from my git tree and
> > try the same assemble command but with --verbose at the end and
> > report the result.
> > 
> > Thanks.
> > NeilBrown
> > 
