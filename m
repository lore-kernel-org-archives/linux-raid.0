From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID and LVM alignment when expanding PVs
Date: Sat, 27 Oct 2012 21:20:17 -0500
Message-ID: <508C9661.2070505@hardwarefreak.com>
References: <CAEQBofHr-Fz=9zuR7WviZ4SRouEygOuX=WQRmg___ErMQyrqnw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEQBofHr-Fz=9zuR7WviZ4SRouEygOuX=WQRmg___ErMQyrqnw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erez Zarum <erezzarum@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My eyes are bleeding and I have a headache after reading this.  I
despise top posting, but there's no other way here.

What you have below is a damn mess.  Throw it all out and do this the
easy, correct way:

1.  Create an mdadm linear array containing the LSI logical devices
2.  mkfs.xfs /dev/md0
3.  Done.

Wasn't that easy?

With SSDs and BBWC latency is zero for practical purposes, so you have
no RMW penalty, making XFS journal/data stripe alignment unnecessary.

The only XFS mount option you need in fstab is nobarrier.  Relatime, the
XFS default, is equivalent to noatime and nodiratime.  The rest of what
you manually specified below are current default values.

Expanding capacity with XFS and a concat (linear array) is simplicity:

Grow the next new LSI logical device into the linear array and grow the
XFS.  Since you haven't specified su/sw your new RAID5 geometry doesn't
have to match the previous ones, i.e. adding a 3 drive or 9 drive RAID5
is fine.  You could even add a RAID10 or RAID6 array and it wold work
just fine.

Given your post below, it's almost assured that you will want me to
expend another post or 3 explaining in minute detail how/why the above
configuration works and why you should use it.  I will not do so here
again.  I've explained the virtues of this setup on this and the Dovecot
list many times and those posts are in multiple internet archives.  I've
given you what you need to know to set this up in a sane and simple high
performance manner.  You can test it yourself or simply ignore my
advice.  That's up to you.

The commands to create and grow an md linear array are in the mdadm man
page.  Those to grow an XFS are in the xfs_growfs man page.  If you need
minor clarification on some point I'll be glad to respond, but I'm not
going to write another thesis on this.

Best of luck.

-- 
Stan


On 10/27/2012 3:49 PM, Erez Zarum wrote:
> Hey,
> Before posting in here i have spent some time searching for answers
> also on the LVM irc channel, I actually don't use the linux raid
> (mdadm) but my question on the behavior of mdadm in conjunction with
> the LVM might answer it.
> The server is going to run MySQL with InnoDB, as i'm not going to
> change InnoDB default block size so the blocksize it uses is 16KiB.
> I have an LSI Controller with a BBU and 25 SSDs disks, (i have total
> 28 at the moment, 3 are hot spares)
> I created 5 Logical Drives (LD), each one is a RAID5 (4+1) with a
> stripe size of 256KiB and presented them to the OS.
> These gave me /dev/sdd /dev/sde /dev/sdf /dev/sdg and /dev/sdh (/dev/sd[defgh]).
> What i wish to achieve is a full utilization of those LDs using one
> block device with a way to expand in the future.
> At first i opted to use SW RAID (mdadm) using RAID0, and then create
> an LVM on top of it, but at the moment i can't expand RAID0 (i know it
> will be possible in the future) so i decided to go with LVM striping.
> So i have created 5 PVs aligned at 1024KiB (4*256KiB), though it's
> LVM's default in RHEL 6.
> 
> $ pvcreate -M2 --pvmetadatacopies 2 --dataalignment=1024k /dev/sdd
> $ pvcreate -M2 --pvmetadatacopies 2 --dataalignment=1024k /dev/sde
> $ pvcreate -M2 --pvmetadatacopies 2 --dataalignment=1024k /dev/sdf
> $ pvcreate -M2 --pvmetadatacopies 2 --dataalignment=1024k /dev/sdg
> $ pvcreate -M2 --pvmetadatacopies 2 --dataalignment=1024k /dev/sdh
> 
> Then i created the VG:
> $ vgcreate -M2 --vgmetadatacopies 2 vg1 /dev/sdd /dev/sde /dev/sdf
> /dev/sdg /dev/sdh
> 
> And then i created a striped LV with 256KiB stripe size and left 5%
> free for snapshots (not that i will do much of them, perhaps once a
> week for a backup and then delete it):
> $ lvcreate -i 5 -I 256k -n lv1 -l 95%FREE vg1 /dev/sdd /dev/sde
> /dev/sdf /dev/sdg /dev/sdh
> 
> As i am using XFS i created it with the following parameters:
> $ mkfs.xfs -d su=256k,sw=20 /dev/vg1/lv1
> 
> And i used the following mount options:
> noatime,nodiratime,nobarrier,logbufs=8,logbsize=256k
> 
> So everything should be aligned now.
> 
> When the time comes and i will need to expand the capacity on the LV i
> will not be able to add more PVs into the LV as it's a striped LV
> (unless i will multiply it by two, but i won't expand in this rate).
> My only option in this setup is to expand the underlying RAID5 by
> adding more disks into it, I will grow by a multiple of 2 per LD.
> I will then have 5 LDs, each one is RAID5 (6+1) with a stripe size of 256KiB.
> I was under the impression it will be simple, i will expand the PVs,
> then the VG and then the LV, this will work, but now the PV won't be
> aligned (or maybe i'm wrong here?)
> Now my stripe width is 1536KiB (6*256KiB), but the PVs were created
> with dataalignment of 1024KiB, which means after adding more disks to
> the underlying RAID5 LDs I am not longer aligned at stripe boundaries.
> 
> As you know, it's not possible to change the PV metadata
> (dataalignment) after it was created.
> So i checked perhaps i can create those PVs (/dev/sd[defgh]) with no
> metadata copies at all (--pvmetadatacopies 0) and then add two small
> devices just for the metadata into the VG (I will never expand those
> devices, so it will be aligned).
> But after creating the PVs with --pvmetadatacopies 0, I saw that it
> still saves small metadata (PVUUID, LABEL, etc..) and for obvious
> reasons.
> I searched and saw it's not possible to write the metadata of the PVs
> to the end of the block device so if i'll grow the LDs (PVs) The data
> will no longer be aligned.
> 
> Because i know i can't extend the LV by adding one or two PVs this is
> my only option, my estimated growth this way is up to 160 disks and i
> will probably migrate the RAID5 to RAID6 (RAID5 with that amount of
> disks is not that reliable), so i will have 5 x RAID6 30+2 at most.
> 
> The other option i see that might work is creating a linear LV from
> those 5 LDs, this will mean i will be able to grow by adding more PVs
> (creating more RAID5 4+1 LDs) to the VG and then extend the LV.
> As my MySQL InnoDB default blocksize is 16KiB (and i have no future
> plans to change it) In either setup single write/read will go to one
> disk.
> The problem i have in this setup is that i couldn't make it work, I
> know i need to align the XFS allocation group with the LV boundaries,
> but i couldn't find a way to do it correctly, during my benchmarks i
> utilized only 1 disk and didn't get that much parallel I/O (regardless
> of threads).
> My other concern is if it's possible after extending the LV to tweak
> xfs AGs (so I will still be on the LV boundaries).
> 
> I ask the question in here, because I think in either way, be it HW
> RAID or SW RAID (mdadm), expanding the PV (underlying block device), i
> will be in the same situation, and as i know mdadm and LVM had some
> kind of integration (LVM read mdadm sysfs for alignment, etc..)
> perhaps i miss something.
> 
> Thanks for any help!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

