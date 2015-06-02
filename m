From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: self healing of MD raid
Date: Tue, 2 Jun 2015 13:01:31 -0500
Message-ID: <CAB-428n7sznvDcwvzABtxw--z8U6_R0xx_P7K=DRskw2Jeiy1g@mail.gmail.com>
References: <20150602172236.GA23446@www5.open-std.org> <20150602175339.GA20741@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150602175339.GA20741@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robin,

Do you know what would be the MD action if it cannot recover the
faulty block from the other members ? Assuming not enough members are
online, does it just print a warning in the dmesg ? Does any one in
the MD layer keep track of the number of corruption events like this ?

--Alireza



On Tue, Jun 2, 2015 at 12:53 PM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Tue Jun 02, 2015 at 07:22:36PM +0200, keld@keldix.com wrote:
>
>> Hi list
>>
>> I wonder if MD RAID software is kind of self healing.
>> That is, if a read operation gets an IO error, then the logical
>> sector of the RAID can be recreated from the other sector(s)
>> of the raid, and then written out on the block which gave a read error.
>>
>> His could work both for the mirrored RAID types, and for the
>> parity orientet RAID types.
>>
>> Is that implemented in MD RAID?
>>
>> Similarily the self healing process could be part of the monitoring
>> background processes.
>>
>> Best regaqrds
>> keld
>
> Yes, this is implemented as standard for all forms of RAID with
> redundant data (parity/mirror). A read error will automatically trigger
> a rewrite of the faulty block with data recovered from the other
> members. This rewrite should also trigger a remapping within the drive
> if the original block proves to be unwritable as well.
>
> Running a regular check (echo check > /sys/block/mdX/md/sync_action)
> will do a full read of all active members in an array and therefore
> trigger rewrites for any unreadable blocks. This is often set up as part
> of the standard distro cron jobs, but should be set up manually if not.
>
> Cheers,
>     Robin
> --
>      ___
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |
