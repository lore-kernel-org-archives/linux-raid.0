From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Feb 2011 15:59:17 -0600
Message-ID: <4D658335.3040401@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6518ED.1080908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6518ED.1080908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson put forth on 2/23/2011 8:25 AM:
> On 23/02/2011 13:56, David Brown wrote:
> [...]
>> Incidentally, what's your opinion on a RAID1+5 or RAID1+6 setup, where
>> you have a RAID5 or RAID6 build from RAID1 pairs? You get all the
>> rebuild benefits of RAID1 or RAID10, such as simple and fast direct
>> copies for rebuilds, and little performance degradation. But you also
>> get multiple failure redundancy from the RAID5 or RAID6. It could be
>> that it is excessive - that the extra redundancy is not worth the
>> performance cost (you still have poor small write performance).
> 
> I'd also be interested to hear what Stan and other experienced
> large-array people think of RAID60. For example, elsewhere in this
> thread Stan suggested using a 40-drive RAID-10 (i.e. a 20-way RAID-0
> stripe over RAID-1 pairs), 

Actually, that's not what I mentioned.  What I described was a 48 drive
storage system consisting of qty 6 RAID10 arrays of 8 drives each.
These could be 6 mdraid10 8 drive arrays using LVM to concatenate them
into a single volume, or they could be 6 HBA hardware RAID10 8 drive
arrays stitched together with mdraid linear into a single logical device.

Then you would use XFS as your filesystem, and its allocation group
architecture to achieve your multi user workload parallelism.  This
works well for a lot of workloads.  Coincidentally, because we have 6
arrays of 8 drives each, instead of one large 48 drive RAID10, the
probability of the "dreaded" 2nd drive failure during rebuild drops
dramatically.  Additionally, the the amount of data exposed to loss due
to this architecture decreases to 1/6th of that of a single large RAID10
of 48 drives.  If you were to lose both drives during the rebuild, as
long as this 8 drive array is not the first array in the stitched
logical device, it won't contain XFS metadata, and you can recover.
Thus, it's possible to xfs_repair the filesystem, only losing the data
contents of the 8 disk array that failed, or 1/6th of your data.  This
failure/recovery scenario is a wild edge case so I wouldn't _rely_ on
it, but it's interesting that it works, and is worth mentioning.

> and I wondered how a 40-drive RAID-60 (i.e. a
> 10-way RAID-0 stripe over 4-way RAID-6 arrays) would perform, both in
> normal and degraded situations, and whether it might be preferable since
> it would avoid the single-disk-failure issue that the RAID-1 mirrors
> potentially expose. My guess is that it ought to have similar random
> read performance and about half the random write performance, which
> might be a trade-off worth making.

First off what you describe here is not a RAID60.  RAID60 is defined as
a stripe across _two_ RAID6 arrays--not 10 arrays.  RAID50 is the same
but with RAID5 arrays.  What you're describing is simply a custom nested
RAID, much like what I mentioned above.  Let's call it RAID J-60.

Anyway, you'd be better off striping 13 three-disk mirror sets with a
spare drive making up the 40.  This covers the double drive failure
during rebuild (a non issue in my book for RAID1/10), and suffers zero
read or write performance, except possibly LVM striping overhead in the
event you have to use LVM to create the stripe.  I'm not familiar enough
with mdadm to know if you can do this nested setup all in mdadm.

The big problem I see is stripe size.  How the !@#$ would you calculate
the proper stripe size for this type of nested RAID and actually get
decent performance from your filesystem sitting on top?

-- 
Stan
