From: Eli Morris <ermorris@ucsc.edu>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Thu, 8 Dec 2011 15:03:54 -0800
Message-ID: <E88BF285-4224-45F8-952A-0248E7025BDD@ucsc.edu>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu> <20111208075709.587ac227@notabene.brown> <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu> <20111208091651.2a56dd5b@notabene.brown> <2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu> <20111209065140.107aa286@notabene.brown> <46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu> <20111209075931.29b26b5e@notabene.brown> <D1EB6C45-E127-4EC6-BFDD-BDFCC4607981@ucsc.edu> <20111209095033.06136f92@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111209095033.06136f92@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 8, 2011, at 2:50 PM, NeilBrown wrote:

> On Thu, 8 Dec 2011 13:42:44 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> 
>> 
>> On Dec 8, 2011, at 12:59 PM, NeilBrown wrote:
>> 
>>> On Thu, 8 Dec 2011 12:39:10 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
>>> 
>>>> 
>>> 
>>>> 
>>>> and here is the verbose assemble output:
>>>> 
>>>> [root@stratus log]# mdadm --verbose --assemble /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 
>>>> mdadm: looking for devices for /dev/md5
>>>> mdadm: /dev/sda1 is identified as a member of /dev/md5, slot 0.
>>>> mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot -1.
>>>> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 2.
>>>> mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 3.
>>>> mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 4.
>>>> mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 5.
>>>> mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
>>>> mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 7.
>>>> mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot -1.
>>>> mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 9.
>>>> mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 10.
>>>> mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 11.
>>>> mdadm: /dev/sdm1 is identified as a member of /dev/md5, slot 12.
>>>> mdadm: /dev/sdn1 is identified as a member of /dev/md5, slot 13.
>>>> mdadm: /dev/sdo1 is identified as a member of /dev/md5, slot -1.
>>>> mdadm: no uptodate device for slot 1 of /dev/md5
>>>> mdadm: added /dev/sdc1 to /dev/md5 as 2
>>>> mdadm: added /dev/sdd1 to /dev/md5 as 3
>>>> mdadm: added /dev/sde1 to /dev/md5 as 4
>>>> mdadm: added /dev/sdf1 to /dev/md5 as 5
>>>> mdadm: added /dev/sdg1 to /dev/md5 as 6
>>>> mdadm: added /dev/sdh1 to /dev/md5 as 7
>>>> mdadm: no uptodate device for slot 8 of /dev/md5
>>>> mdadm: added /dev/sdj1 to /dev/md5 as 9
>>>> mdadm: added /dev/sdk1 to /dev/md5 as 10
>>>> mdadm: added /dev/sdl1 to /dev/md5 as 11
>>>> mdadm: added /dev/sdm1 to /dev/md5 as 12
>>>> mdadm: added /dev/sdn1 to /dev/md5 as 13
>>>> mdadm: no uptodate device for slot 14 of /dev/md5
>>>> mdadm: no uptodate device for slot 15 of /dev/md5
>>>> mdadm: added /dev/sdb1 to /dev/md5 as -1
>>>> mdadm: added /dev/sdi1 to /dev/md5 as -1
>>>> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
>>>> mdadm: added /dev/sda1 to /dev/md5 as 0
>>>> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to start the array.
>>>> 
>>>> 
>>> 
>>> Thank.
>>> 
>>> I know what the 'busy' thing is now.
>>> sdo1 appears the be the 'same' as some other device in some way.
>>> 
>>> Also it looks like you might have turned some drives into spares
>>> unintentionally, though I'm not sure
>>> 
>>> Could you pleas send "mdadm --examine" output for all of these drives and
>>> I'll have a look.
>>> 
>>> Thanks,
>>> NeilBrown
>>> 
>>> 
>>> 
>> 
>> Thanks Neil. I wasn't sure if you wanted the output of all the drives or just the 'removed' ones, so here is the output for all the drives in the array.
>> 
>> Just FYI, I don't know what I could have done to make these spares. Between when things worked fine and when they did not, I did not make any hardware or configuration changes to the array.
>> 
> 
> Thanks.  I did want it all (it is always better to give too much than to
> little - so thanks).
> 
> Those devices have be turned into spares.  Maybe an "--add" command or
> possibly even a "--re-add" though it shouldn't.  Newer versions of mdadm are
> more careful about this.
> 
> You need to re-"Create" the array.  This doesn't affect the data, just writes
> new metadata.
> It looks like it is safe to assume that none of the devices have been
> renamed.  However if you have any reason to believe that the devices don't
> belong in the array in the 'obvious' order, you should let me know or adjust
> the command below accordingly.
> 
> You want to create the array exactly as it was, and you want to make sure
> it doesn't immediately start to resync, just in case something goes wrong and
> we want to try again.
> 
> All the 'Data Offset's are the same and are 2048 (1M) which is the current
> default so that is good.
> 
> So:
>  mdadm --create /dev/md5 -l5 --layout=left-symmetric --chunk=512 \
>  --raid-disks=16  --assume-clean /dev/sd[a-p]
> 
> This will over-write all the metadata but not touch the data.
> 
> Then you probably want to
>  fsck -n /dev/md5
> 
> to make sure it looks good.  If it does,
> 
> echo check > /sys/block/md5/md/sync_action
> 
> That will read all blocks and  make sure parity is correct.  When it finishes
> check
>   /sys/block/md5/md/mismatch_cnt
> 
> if this is zero or close to zero, then it is looking very good.
> If it is a lot more than zero (as  > 10000) then we probably need to think
> again.
> If it is small but non-zero, then "echo repair > ...the same /sync_action"
> will fix it up.
> 
> If fsck showed any issues, run
>  fsck -f /dev/md5
> to fix them, then mount the filesystem and all should be good.
> 
> What version of mdadm do you have?
> 
> Thanks,
> NeilBrown
> 


Hi Neil,

Thanks. I have:

mdadm - v3.1.3 - 6th August 2010, which is the default up to date version on Centos 6.0

One question: is the command:

>  mdadm --create /dev/md5 -l5 --layout=left-symmetric --chunk=512 \
>  --raid-disks=16  --assume-clean /dev/sd[a-p]

Or 

 mdadm --create /dev/md5 -l5 --layout=left-symmetric --chunk=512 \
 --raid-disks=16  --assume-clean /dev/sd[a-p]1



Note that partition number on the drives: /dev/sd[1-p]1 instead of /dev/sd[a-p]

thanks,

Eli

mdadm --create /dev/md5 -l5 --layout=left-symmetric --chunk=512 \
>  --raid-disks=16  --assume-clean /dev/sd[a-p]
mdadm: partition table exists on /dev/sda but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdd but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdf but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdg but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdh but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdi but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdj but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdk but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdl but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdm but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdn but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdo but will be lost or
       meaningless after creating array
mdadm: partition table exists on /dev/sdp but will be lost or
       meaningless after creating array
Continue creating array? n






