From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: File system corruption during setting new size (native/extarnal
 metatdat) after expansion
Date: Thu, 17 Feb 2011 08:45:36 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D178EC3637@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D178EC32BC@irsmsx503.ger.corp.intel.com>
 <20110217153815.2212b13d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217153815.2212b13d@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Thursday, February 17, 2011 5:38 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: File system corruption during setting new size
> (native/extarnal metatdat) after expansion
> 
> On Wed, 16 Feb 2011 15:24:53 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> > Hi,
> >
> > I've met again array_size change problem. A while ago I've indicated
> it, during array expansion, file system corruption occurs.
> > The previous conclusion was that my tests were wrong (too small
> arrays, on bigger arrays it seems to be ok),
> > I've got now reproduction in our lab on quite big arrays (250G) and
> on my small test arrays also.
> >
> > This problem is related to array expansion using native and external
> metadata.
> >
> > Problem is that after expansion file system on array is corrupted.
> > Operation that corrupts file system is array size change via sysfs
> (and for native metadata during reshape finalization in md).
> > In logs I've got information:
> > 	VFS: busy inodes on changed media or resized disks
> >
> > My investigation in md goes to block_dev.c/inode.c and flush_disk()
> (called from check_disk_size_change()).
> > I've found above text there (about busy inodes).
> > My traces shows that in __invalidate_inodes(), inode->i_count == 2
> and it is locked. This makes me to look how invalidate_inodes() is
> called.
> > Before invalidate_inodes() is called, cache is cleared by
> shrink_dcache_sb().
> > If I've commented shrink_dcache_sb() file system seems to be safe. It
> is the same when invalidate_inodes() is commented (shrink_cache_sb()
> called only).
> > If I've changed functions order (1. invalidate_inodes(), 2.
> shrink_dcache_sb()) in __invalidate_device() (block_dev.c) there is no
> corruption also.
> > When after shrink_dcache_sb() is called invalidate_inodes() on busy
> inodes corruption occurs (if it called earlier it doesn't matter).
> >
> > This problem can be reproduced on mounted arrays only. If array is
> not mounted, file system corruption disappears.
> > This means that whole expansion process is correct.
> > In some cases (rarely) inodes on mounted device are not locked and
> then FS corruption doesn't happened.
> >
> >
> > I'd like to know your opinion.
> > Do you think that problem is in releasing cache but not all inodes
> (busy case), commands order...
> > ... or probably changing size on mounted array is a mistake (for
> current code)?
> >
> > BR
> > Adam
> >
> >
> > ---------------------------------
> > My test commands:
> >
> > #create container
> > mdadm -C /dev/md/imsm0 -amd -e imsm -n 3 /dev/sdb /dev/sdc /dev/sde -
> R
> >
> > #create volume
> > mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --size 104857 -n 3
> /dev/sdb /dev/sdc /dev/sde -R
> > mkfs /dev/md/raid5vol_0
> > mount /dev/md/raid5vol_0 /mnt/vol
> >
> > #copy some files from current directory
> > cp * /mnt/vol
> >
> > #add spare
> > mdadm --add /dev/md/imsm0 /dev/sdd
> >
> > #start reshape
> > mdadm --grow /dev/md/imsm0 --raid-devices 4 --backup-file=/backup.bak
> 
> Thanks for the script - that makes things a lot easier.
> 
> I had to add some "mdadm --wait" commands etc to make it work reliably,
> but
> then I could get it to generate filesystem corruption quite easily.
> 
> I also had "mdmon" crashing because imsm_num_data_members got a 'map'
> of NULL,
> and then tried to get_imsm_raid_level on it.  Something needs to be
> fixed
> there (I hacked it so that if it got a NULL, it tried again with
> second_map
> == 0, but I don't know if that is right).
> 
> The problem seems to be in the VFS/VM layer.  I can see two ways to fix
> it.
> I'll see if I can find some who wants to take responsibility and make a
> decision.
> 
> 1/ in invalidate_inodes (in fs/inodes.c), inside the loop, add a
> clause:
> 
> 		if (inode->i_state & I_DIRTY)
> 			continue;
> 
>   That is what is causing the problem - dirty inodes are being
> discarded.
> 
> 2/ in check_disk_size_change (in fs/block_dev.c), replace
> 
>          flush_disk(bdev);
>    with
> 
>          if (disk_size == 0 || bdev_size == 0)
>                flush_disk(bdev);
> 
>  because I don't think there is any justification for calling
> flush_bdev if
>  we are just changing the size of the disk - though I don't really know
> why
>  that is there at all, so it is hard to say for sure.   Certainly if
>  disk_size > bdev_size we shouldn't be calling flush disk.
> 
> So I suggest you make one of those changes to continue with your
> testing, and
> I'll try to get something sorted out.
> 
> If you could look into the circumstances that might make
> imsm_num_data_members
> get a NULL map, I would appreciate that.
> 
> Thanks,
> NeilBrown

Thank you for workarounds/temporary fixes.

Regarding imsm_num_data_members() setting second_map to 0 cannot help as it is always called with this parameter set to 0.
In this situation, when first map should be always present, we can have some race condition.
I have no reproduction for mdmon crash you are observing, but I'll try some changes in my scripts and I'll carefully watch any signs 
that can indicate reproduction of this problem.

If you could let me know details about changes you made to my scenario, it could help.

Thanks again
Adam



 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
