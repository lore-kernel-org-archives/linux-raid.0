From: linbloke <linbloke@fastmail.fm>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Wed, 02 May 2012 12:37:55 +1000
Message-ID: <4FA09E03.9090102@fastmail.fm>
References: <4F9AFBC6.7070803@weboperative.com> <20120428080355.70585026@notabene.brown> <20120501094508.GA24134@nsrc.org> <20120501201854.19f7def9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120501201854.19f7def9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Brian Candler <B.Candler@pobox.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Jan Ceuleers <jan.ceuleers@computer.org>
List-Id: linux-raid.ids

On 1/05/12 8:18 PM, NeilBrown wrote:
> On Tue, 1 May 2012 10:45:08 +0100 Brian Candler<B.Candler@pobox.com>  wrote:
>
>> On Sat, Apr 28, 2012 at 08:03:55AM +1000, NeilBrown wrote:
>>> I'm afraid you've been bitten by a rather nasty bug which is present in 3.3
>>> and got back ported to some -stable kernel.  The fix has been submitted and
>>> should be appearing in -stable kernels soon (maybe already).
>> Do you happen to know if this bug was present in ubuntu 11.10, kernel
>> versions 3.0.0-15-server or 3.0.0-16-server ?
> I don't keep track of what ubuntu (or anyone but suse) put in their kernels,
> sorry.

I wondered about Ubuntu and checked the kernel package changelog:
http://changelogs.ubuntu.com/changelogs/pool/main/l/linux/linux_3.0.0-19.33/changelog

Cross-checking with the commit nominated by Jan Ceuleers to this list on 
30/04/12 (c744a65c1e2d59acc54333ce8) and the Ubuntu changelog (see grep 
below) - I don't believe Ubuntu 11.10 includes the bug.

Cheers,

lb


$ grep ' md' changelog
   * md/bitmap: ensure to load bitmap when creating via sysfs.
   * md/raid1,raid10: avoid deadlock during resync/recovery.
   * net: Fix driver name for mdio-gpio.c
   * tcp: md5: using remote adress for md5 lookup in rst packet
   * md/raid5: fix bug that could result in reads from a failed device.
   * md/raid5: abort any pending parity operations when array fails.
   * md: Avoid waking up a thread after it has been freed.
   * md/raid5: fix bug that could result in reads from a failed device.
   * tcp: properly handle md5sig_pool references
   * md/linear: avoid corrupting structure while waiting for rcu_free to
   * md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.
   * winbond: include linux/delay.h for mdelay et al
   * md: fix 'degraded' calculation when starting a reshape.
   * md: fix small irregularity with start_ro module parameter
   * SCSI: st: fix mdata->page_order handling
   * md: Fix unfortunate interaction with evms
   * md/bitmap: protect against bitmap removal while being updated.
   * md: Fix "strchr" [drivers/md/dm-log-userspace.ko] undefined!





>> I saw failures to assemble RAID6 arrays after unclean shutdowns on both of
>> these, just in test environments.  If it happens again I'll send mdadm
>> --examine output. I just tried to replicate it and failed :-(
> To replicate:
>
>   - create an array.
>   - stop the array
>   - assemble the array with at least one missing device e.g.:
>      mdadm -A /dev/md0 /dev/sda1 /dev/sdb1
>     if it was a 3-device array
>   - check in /proc/mdstat that it is listed as "inactivate"
>   - reboot
>   - now "mdadm -E" the devices.  If the raid level is -unknown- then the bug
>     has hit.
>
> NeilBrown
>
>
>> Regards,
>>
>> Brian.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
