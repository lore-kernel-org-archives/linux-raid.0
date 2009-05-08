From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 09 May 2009 00:29:12 +0200
Message-ID: <87ws8r2pqf.fsf@frosties.localdomain>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
	<e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
	<1241406283.17240.26.camel@ezra> <87fxff462s.fsf@frosties.localdomain>
	<21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>
	(NeilBrown's message of "Sat, 9 May 2009 08:16:27 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Daniel Reurich <daniel@centurion.net.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"NeilBrown" <neilb@suse.de> writes:

> On Sat, May 9, 2009 7:50 am, Goswin von Brederlow wrote:
>
>>>> So I still plan to offer a "--reserve-space=2M" option for mdadm to
>>>> allow the first 2M of each device to not used for raid data.  Whether
>>>> any particular usage of this option is viable or not, is a different
>>>> question altogether.
>>
>> How exactly would that layout be then?
>>
>> Block  0   bootblock
>> Block  1   raid metadata
>> Block  x   2M reserved space
>> Block x+2M start of raid data
>>
>> Like this?
>
> When using 1.2 metadata, yes, possible with bitmap
> inserted  between the reserved space and the start of raid data.

That realy seems to be the best option. Simple to implement, simple to
use and if mdadm copies the reserved space from old to new drives when
adding one it gives us exactly what we want.

Are you working on that already or do you think it needs more discussion?

> When using 1.0, it would be
>
>   Block 0..N-1   boot block and second stage
>   Block N..near-the-end raid data
>   Block x..y     bitmap
>   block z        superblock

I never liked the idea of 1.0.

What actualy does happen when you have raid on partitions and resize a
partition? Am I right that the raid then can't be assembled until the
raid itself gets grown (and the superblock gets moved to the new end)?

> NeilBrown

