From: Sonu a <p10sonu@gmail.com>
Subject: Re: md disk fault communication code
Date: Fri, 18 Apr 2014 14:47:06 +0800
Message-ID: <CAAcCrhTeVEbK4LptB32teOSaqbQXQ=gYmnw5RzWv1RcbB7=u_Q@mail.gmail.com>
References: <CAAcCrhQEW4Yzz2YQri3hzNExQVWqquvN8dzzxZN+5DBZbAtcRw@mail.gmail.com>
	<20140418161334.025262bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140418161334.025262bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes it does when there is IO failure But.

But my question was when disk fail silently with out IO as show below.

The md sysfs interface /sys/block/mdY/md/dev-sdX/state is written with
faulty when sd corresponding disk is deleted with..

echo 1 >  /sys/block/sdc/device/delete

kernel: [21853.981735] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
kernel: [21854.049967] md: md0 still in use.
kernel: [21854.051201] md/raid1:md0: Disk failure on sdc, disabling device.
kernel: [21854.051201] md/raid1:md0: Operation continuing on 1 devices.
kernel: [21854.308355] sd 2:0:0:0: [sdc] Stopping disk
kernel: [21854.415122] ata3.00: disabled
kernel: [21854.467540] md: unbind<sdc>
kernel: [21854.467544] md: export_rdev(sdc)

earlier stack dump which shows the sysfs write interface

there has to be code monitoring block disk state, and propagating that
state to the md ?

Thx.

On Fri, Apr 18, 2014 at 2:13 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 18 Apr 2014 13:38:58 +0800 Sonu a <p10sonu@gmail.com> wrote:
>
>> when disk is removed with out mdadm as I see from the stack below the
>> communication reaching the md driver.
>>
>> dump_stack+0x49/0x5e
>> md_error+0x50/0x110 [md_mod]
>> state_store+0x43/0x300 [md_mod]
>> rdev_attr_store+0xad/0xd0 [md_mod]
>> ? sysfs_write_file+0x62/0x1c0
>> sysfs_write_file+0x138/0x1c0
>> vfs_write+0xc0/0x1e0
>> SyS_write+0x5a/0xa0
>> ? __audit_syscall_exit+0x246/0x2f0
>> system_call_fastpath+0x16/0x1b
>>
>> could someone point me to the code which is monitoring scsi disks
>> status and thus calling md driver sysfs interface accordingly ?
>
> I think you ask asking how md_error gets called when a SCSI device fails,
> having already discovered how it is called when you explicitly write to a
> sysfs file.
>
> Nothing monitors the scsi disks.  md only discovers failure if it sends a
> request to a disk, and the request signals an error.  If you search for
> 'bi_end_io', functions assigned to this field are called when a request
> finishes.  Those functions might call md_error if the request failed, or they
> might schedule some other handling first to try to correct the error.
>
> NeilBrown
