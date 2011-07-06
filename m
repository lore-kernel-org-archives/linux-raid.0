From: Petter Reinholdtsen <pere@hungry.com>
Subject: Re: Help with recovering resized raid where machine crashed while PENDING
Date: Wed, 6 Jul 2011 22:41:02 +0200
Message-ID: <20110706204102.GH18875@login1.uio.no>
References: <2flfwmpdpw2.fsf@login1.uio.no> <20110705104923.4779e295@notabene.brown> <20110705162433.GB18875@login1.uio.no> <20110706093917.28cafc31@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110706093917.28cafc31@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Neil Brown]
> Bug I expect... though actually it might be a different one to what
> I was thinking.

Good to hear that this was not the way it was supposed to work.  The
failing RAID really had me worried that my files were lost. :)

> Try to assemble the array normally with --verbose.
> i.e.
> 
>   mdadm --assemble /dev/md3 --verbose /dev/sd[abcde]2
> (or whatever the right list of devices is).
> 
> If this fails with something like
> 
>    mdadm: too-old timestamp on backup-metadata on ....

This is the message I saw:

meta:/dev# mdadm --assemble --verbose /dev/md3 sdb2 sdg2 sdh2 sdc2 sdf2
mdadm: looking for devices for /dev/md3
mdadm: sdb2 is identified as a member of /dev/md3, slot 0.
mdadm: sdg2 is identified as a member of /dev/md3, slot 4.
mdadm: sdh2 is identified as a member of /dev/md3, slot 3.
mdadm: sdc2 is identified as a member of /dev/md3, slot 1.
mdadm: sdf2 is identified as a member of /dev/md3, slot 2.
mdadm:/dev/md3 has an active reshape - checking if critical section needs to be restored
mdadm: too-old timestamp on backup-metadata on device-3
mdadm: too-old timestamp on backup-metadata on device-4
mdadm: Failed to find backup of critical section
mdadm: Failed to restore critical section for reshape, sorry.
      Possibly you needed to specify the --backup-file
meta:/dev# 

> then you can assemble the array by 
> 
>    export MDADM_GROW_ALLOW_OLD=1
>    mdadm --assemble ....(same command as above).
> 
> This requires mdadm-3.1.2 or newer.

And this worked great!

meta:/dev# MDADM_GROW_ALLOW_OLD=1 mdadm --assemble --verbose /dev/md3 sdb2 sdg2 sdh2 sdc2 sdf2
mdadm: looking for devices for /dev/md3
mdadm: sdb2 is identified as a member of /dev/md3, slot 0.
mdadm: sdg2 is identified as a member of /dev/md3, slot 4.
mdadm: sdh2 is identified as a member of /dev/md3, slot 3.
mdadm: sdc2 is identified as a member of /dev/md3, slot 1.
mdadm: sdf2 is identified as a member of /dev/md3, slot 2.
mdadm:/dev/md3 has an active reshape - checking if critical section needs to be restored
mdadm: accepting backup with timestamp 1308555399 for array with timestamp 1309424388
mdadm: restoring critical section
mdadm: added sdc2 to /dev/md3 as 1
mdadm: added sdf2 to /dev/md3 as 2
mdadm: added sdh2 to /dev/md3 as 3
mdadm: added sdg2 to /dev/md3 as 4
mdadm: added sdb2 to /dev/md3 as 0
mdadm: /dev/md3 has been started with 5 drives.
meta:/dev# 

Happy hacking,
-- 
Petter Reinholdtsen
