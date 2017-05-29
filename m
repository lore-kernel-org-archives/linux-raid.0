From: Nix <nix@esperi.org.uk>
Subject: Re: mdadm --misc --readonly -> ENODEV indefinitely
Date: Mon, 29 May 2017 13:20:23 +0100
Message-ID: <87bmqbzwfs.fsf@esperi.org.uk>
References: <87y3th2rdu.fsf@esperi.org.uk>
        <877f10hgx8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f10hgx8.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 29 May 2017 06:20:35 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 May 2017, NeilBrown told this:

> On Sun, May 28 2017, Nix wrote:
>
>> So I was trying to flip on the RAID journal now I'd fully populated my
>> array and cut over to it. So, from early userspace, I did
>>
>>    # first line done by initramfs scripting
>>    /sbin/mdadm --assemble --scan --auto=md --freeze-reshape
>>    mdadm --misc --readonly /dev/md/fast
>>    mdadm --manage /dev/md/fast --add-journal /dev/ssd1
>>    mdadm --misc --readwrite /dev/md/fast
>>
>> This did not work as planned, or indeed at all. After the first
>> --readonly, all requests for /dev/md/fast report "No such device or
>> address" until a reboot, though /proc/mdstat says the thing is still
>> there and /sys/block/md125/dev reports no change in major/minor numbers.
>> (I don't have udev in my early-userspace environment, but mdev reports
>> no change, either.)
[...]
> Commit: 065e519e71b2 ("md: MD_CLOSING needs to be cleared after called md_set_readonly or do_md_stop")
>
> Broken in v4.9-rc1
> Fixed in v4.12-rc1

Oh, apologies -- I should have checked master. :/ didn't think of it.
(And the fix hasn't hit stable in the two months since. I sort of
assumed promotion to stable was usually faster than that... but I guess
it depends on how much free time gregkh has.)

... my arrays are all humming along now, RAID-6ed and much faster than
they ever were with hardware RAID. I'm back in md land for good, where
bugs can actually get *fixed* without booting off a DOS floppy and doing
a reflash of horrible non-free firmware that if it goes wrong will make
my machine unusable.

The sense of freedom is undeniable :) thank you, mders one and all!

-- 
NULL && (void)
