From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: Protecting mddev with barriers to avoid races
Date: Fri, 22 May 2009 18:58:27 +1000 (EST)
Message-ID: <21131647e50f4a99c4a3b4261d1227be.squirrel@neil.brown.name>
References: <37d33d830905220118o1c5d6518l49b3dd1177d0a25e@mail.gmail.com>
    <20090522083641.GQ11504@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090522083641.GQ11504@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 22, 2009 6:36 pm, Andre Noll wrote:
> On 13:48, SandeepKsinha wrote:
>> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
>> Date:   Fri May 22 13:46:56 2009 +0530
>>
>>     Protecting mddev with barriers to avoid races.
>>
>> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
>> index 9ad6ec4..e2dbda8 100644
>> --- a/drivers/md/linear.c
>> +++ b/drivers/md/linear.c
>> @@ -28,10 +28,12 @@
>>  static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
>>  {
>>         int lo, mid, hi;
>> -       linear_conf_t *conf = mddev_to_conf(mddev);
>> +       linear_conf_t *conf;
>>
>>         lo = 0;
>>         hi = mddev->raid_disks - 1;
>> +       barrier();
>> +       conf = mddev_to_conf(mddev);
>
> Are you sure that a compiler barrier is sufficient here? Maybe we
> need smp_mb(), but I'm not familar with all the different memory
> barrier types that exist in the kernel.

I think we just want a read barrier here:
    smb_rmb();
because it is a barrier between reading mddev->raid_disk and
reading mddev->private.

In linear_add, we want a write barrier
    smb_wmb();
before setting mdev->raid_disks, and I think we also want one
before setting mddev->private to make sure that all the assignments
to newconf->whatever are stable.

NeilBrown


