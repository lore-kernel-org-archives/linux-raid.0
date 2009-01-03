From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Sat, 3 Jan 2009 11:03:22 -0800 (PST)
Message-ID: <744918.61915.qm@web30806.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan> <480194.8807.qm@web30808.mail.mud.yahoo.com> <26FE68629F5947799772AAAFA8A6DF6F@m5> <889784.63168.qm@web30805.mail.mud.yahoo.com> <495F5E17.4070600@anonymous.org.uk> <432505.65026.qm@web30805.mail.mud.yahoo.com> <495F8EE1.3030007@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, all the devices are marked clean, so that doesn't appear to be the problem.  but thanks to your link I was reminded that the assemble command has a verbose option.  It gives us a much better clue:

# mdadm /dev/md1 --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdi1 /dev/sdj1 --force --verbose

md: md1 stopped.
md: unbind<sdi1>
md: export_rdev(sdi1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdf1>
md: export_rdev(sdf1)
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 0
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 4
mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 5
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 6
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 0
mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 0
mdadm: no uptodate device for slot 1 of /dev/md1
mdadm: no uptodate device for slot 2 of /dev/md1
mdadm: no uptodate device for slot 3 of /dev/md1
md: bind<sdc1>
mdadm: added /dev/sdc1 to /dev/md1 as 4
md: bind<sdd1>
mdadm: added /dev/sdd1 to /dev/md1 as 5
md: bind<sdc1>
mdadm: added /dev/sde1 to /dev/md1 as 6
md: bind<sdi1>
mdadm: added /dev/sdi1 to /dev/md1 as 0
mdadm: /dev/md1 assembled from 4 drives - not enough to start the array.


Any ideas as to what the issue here is?  How did the slot info get corrupted?  How can I tell which slot is being these drives belong to?  I have backups of the system, so if this is mentioned in a log file, I can probably get it, but the device names are all different now because of the controller failure and the bypassing of the backplane.

thx
mike











----- Original Message ----
From: John Robinson <john.robinson@anonymous.org.uk>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Saturday, January 3, 2009 8:14:25 AM
Subject: Re: Need urgent help in fixing raid5 array

On 03/01/2009 15:49, Mike Myers wrote:
> Ugh.  This would explain a lot!  i'll try this out and see if it can help get md1 back online.

Good luck; the rest of that thread's probably worth a read before starting in too, just to see whether you need to mention your two dirty members first or last.

As Guy suggested earlier in this thread, you might try doing your reassemble while missing out the one with the apparently completely hosed superblock, to at least get the thing up in degraded mode, then test fsck it (e.g. `e2fsck -n`) and mount it read-only to see if you've still got any data. And perhaps take a backup then.

>  Is the only way to regenerate a superblock on a member doing a a create with the assume-clean option?

I'm not sure, but I expect so. Seconding what Justin said much earlier in this thread, personally I'd wait until one of the gurus arrives, in their shining armour and on their white charger, before trying this.

Cheers,

John.



      
