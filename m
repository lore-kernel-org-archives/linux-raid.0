From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: RAID-5 creation crashes when files system installed while           recovery going on
Date: Wed, 24 Jun 2009 16:45:57 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07A318FD@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0797AC80@SDCEXCHANGE01.ad.amcc.com>    <a5f578de750a09c145f5d4f50e90a4f8.squirrel@neil.brown.name>    <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABE5@SDCEXCHANGE01.ad.amcc.com> <a765142d3b99baf3edb3da397b2ee350.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi Dan,
   I am suspecting that ADMA driver has all the XOR operations queued up
for processing and file-system mount is not waiting till ADMA finishes
all the requests. Is this working fine on Intel IO-Processor ?
Thanks and Regards,
Marri

-----Original Message-----
From: Tirumala Reddy Marri 
Sent: Wednesday, June 24, 2009 3:36 PM
To: 'NeilBrown'
Cc: linux-raid@vger.kernel.org; Dan Williams
Subject: RE: RAID-5 creation crashes when files system installed while
recovery going on


I could not reproduce the panic. But there is one other data point is
when I tried to mount the /dev/md0 after file system installation it
failed to mount. Once the MD recover is done I was able to mount the
drive.
Thanks,
Marri

------- here is log-----
# mkfs.ext3 -b 65536 /dev/md0
Warning: blocksize 65536 not usable on most systems.
mke2fs 1.38 (30-Jun-2005)
Filesystem label=
OS type: Linux
Block size=65536 (log=6)
Fragment size=65536 (log=6)
471040 inodes, 468750 blocks
23437 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=536805376
8 block groups
65528 blocks per group, 65528 fragments per group
58880 inodes per group
Superblock backups stored on blocks: 
        65528, 196584, 327640, 458696

Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 33 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
# mount -t ext3 /dev/md0 /mnt/tmpmnt/
EXT3-fs: invalid journal inode.
mount: mounting /dev/md0 on /mnt/tmpmnt/ failed: Invalid argument
# mount  /dev/md0 /mnt/tmpmnt/       
EXT3-fs: invalid journal inode.
EXT2-fs: corrupt root inode, run e2fsck
mount: mounting /dev/md0 on /mnt/tmpmnt/ failed: Invalid argument
# md: md0: recovery done.
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
 disk 3, o:1, dev:sdd

# 
# mount -t ext3 /dev/md0 /mnt/tmpmnt/
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
# df
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/ram0                63461     44131     19330  70% /
/dev/md0              29939456    525568  27913920   2% /mnt/tmpmnt

-----------

-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Tuesday, June 23, 2009 11:56 PM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org; Dan Williams
Subject: RE: RAID-5 creation crashes when files system installed while
recovery going on

On Wed, June 24, 2009 4:39 pm, Tirumala Reddy Marri wrote:
> My meaning of crash was kernel panic happens.  BTW we have HW
acceleration
> to do the XOR calculations which uses ADMA driver model.
> Thanks,
> MArri

Is it possible to get details of this panic?  A digital photo
of the screen perhaps?

NeilBrown

>
> ________________________________
>
> From: linux-raid-owner@vger.kernel.org on behalf of NeilBrown
> Sent: Tue 6/23/2009 7:31 PM
> To: Tirumala Reddy Marri
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID-5 creation crashes when files system installed while
> recovery going on
>
>
>
> On Wed, June 24, 2009 8:35 am, Tirumala Reddy Marri wrote:
>> All,
>>  I started RAID-5 creation using mdadm command. While recovery is
>> happening I tried to install file system . I see intermittent crash
.
>> And crash doesn't happen at fixed location. Any clue what could be
the
>> problem? How does the read/writes to MD driver handled while RAID-5
is
>> under building.
>
> Can you describe exactly what you mean by "crash" ??
>
> The raid5 driver normally has no problems handling writes while
> it is resyncing.  It has a 'stripe_cache' which is used to
> synchronise regular IO with resync IO.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

