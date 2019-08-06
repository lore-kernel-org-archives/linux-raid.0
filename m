From: riccardofarabia@gmail.com
Subject: Re: Bisected: Kernel 4.14 + has 3 times higher write IO latency
 than Kernel 4.4 with raid1
Date: Tue, 06 Aug 2019 00:57:30 -0400
Message-ID: <6a1dcbe6e3ddb03912f8904a368d40c09dd22bd1.camel@gmail.com>
References: <CAMGffEkotpvVz8FA78vNFh0qZv3kEMNrXXfVPEUC=MhH0pMCZA@mail.gmail.com>
         <0a83fde3-1a74-684c-0d70-fb44b9021f96@molgen.mpg.de>
         <CAMGffE=_kPoBmSwbxvrqdqbhpR5Cu2Vbe4ArGqm9ns9+iVEH_g@mail.gmail.com>
         <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com>
         <87h86vjhv0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h86vjhv0.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Alexandr Iarygin <alexandr.iarygin@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hello Linux raid folks?

I've joined this email ring to ask for help (I'd be happy to try to
help in return, but I doubt that I could help anyone with advanced raid
issues.  Maybe I can return any love in other non-raid ways?  Ah well..
I've been using linux raid for a quite a few years, but until now, I
haven't had to rescue data from an array.

I have some data on a 5-disk, raid 10 array that was set-up as the os
for a fedora 28 box that I used as both a hypervisor and workstation /
desktop.  I set that up with anaconda, the fedora installer, and I set
the raid level to 10, used lvm2 and xfs as the file system.  So there
is one lvm volume / group, on the physical raid, that group has several
partitions for /root, /var, /swap and etc.

I would ordinarily have completd back-ups (actualy I usually use NAS
for all data and never keep data locally) and use the disks as door
stops, but I wouldn't mind getting some pictures and videos back that
are on this array.  Also there's a current vm on there that I'd like to
get back if I can.  I had to rebuild this box because the raid array
seemed to have failed and the last box wouldn't boot.

Can I ask for help from this group?

I have attached the drives to another box, this one that I'm using now.
It is running fedora 30 (nice os / distro). I can see the drives, and I
can start the array with 4 of 5 disks, using mdadm -assemble and the
devices or the UUID, but I can't seem to mount the array to see the
data.

I've checked all the disks with the SMART test routine of the gnome
disks gui utility.  A couple have bad sectors but they all are labeled
as OKAY but the SMART Test...

I'm working through the RAID Recovery pages from the wiki that gave me
this email ring.  https://raid.wiki.kernel.org/index.php/RAID_Recovery

Thanks for considering!

Rick Nilsson

On Tue, 2019-08-06 at 09:46 +1000, NeilBrown wrote:
> On Mon, Aug 05 2019, Jinpu Wang wrote:
> 
> > Hi Neil,
> > 
> > For the md higher write IO latency problem, I bisected it to these
> > commits:
> > 
> > 4ad23a97 MD: use per-cpu counter for writes_pending
> > 210f7cd percpu-refcount: support synchronous switch to atomic mode.
> > 
> > Do you maybe have an idea? How can we fix it?
> 
> Hmmm.... not sure.
> 
> My guess is that the set_in_sync() call from md_check_recovery()
> is taking a long time, and is being called too often.
> 
> Could you try two experiments please.
> 
> 1/ set  /sys/block/md0/md/safe_mode_delay 
>    to 20 or more.  It defaults to about 0.2.
> 
> 2/ comment out the call the set_in_sync() in md_check_recovery().
> 
> Then run the least separately after each of these changes.
> 
> I the second one makes a difference, I'd like to know how often it
> gets
> called - and why.  The test
> 	if ( ! (
> 		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
> 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
> 		(mddev->external == 0 && mddev->safemode == 1) ||
> 		(mddev->safemode == 2
> 		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
> 		))
> 		return;
> 
> should normally return when doing lots of IO - I'd like to know
> which condition causes it to not return.
> 
> Thanks,
> NeilBrown
