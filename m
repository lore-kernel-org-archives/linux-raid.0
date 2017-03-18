From: Alfred Matthews <asm13243546@gmail.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Sat, 18 Mar 2017 13:11:54 -0400
Message-ID: <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
 <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com>
 <87d1djdz8y.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1djdz8y.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for the delay. Thanks for the reply.

You're correct, there is no hardware RAID in the available lsdrv; I've
removed each drive from its housing in the controller because it's
Thunderbolt-only, Thundderbolt is borked on OSX here, and I'm rescuing
on Linux. I appreciate your diagnosis and will try, and will write
back.

On 14 March 2017 at 22:56, NeilBrown <neilb@suse.com> wrote:
> On Tue, Mar 14 2017, Alfred Matthews wrote:
>
>>> Does
>>>   dmraid -b /dev/sda /dev/sdb /dev/sdc
>>> tell you anything useful?
>>>
>>
>> # dmraid -b /dev/sdb /dev/sdc
>> /dev/sdc:   5860533168 total, "WD-WCAWZ2927144"
>> /dev/sdb:   5860533168 total, "WD-WCAWZ2939730"
>
>
> No, not useful.
>
> Your other output also doesn't show anything interesting.
> I had another look at the lsdrv output you showed before and I'm
> wondering if there really is anything "hardware RAID" here at all.
>
> Both drives (sdb and sdc) are partitioned into a 200MB EFI partition, a
> 2.75TB hfsplus (Apple file system) / unknown partition, and a 128M
> hfsplus boot partition.
>
> Maybe the two 2.75TB paritions were raided together.
> sdc looks like the "first" device if this were the case.
> Try:
>
>   mdadm --build /dev/md0 --level=0 -n2 --chunk=512M /dev/sdc2 /dev/sdb2
>
> Then try fsck.hfs of hpfsck ... in the "hfsplus" package on Debian.
>  hpfsck /dev/md0
> maybe.
>
> NeilBrown



-- 

Alfred S. Matthews

Software, Visuals, Music

Atlanta, Georgia, US

+1.337.214.4688
