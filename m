From: Ben Nemec <lists@nemebean.com>
Subject: Re: Replacing a drive in RAID 0
Date: Tue, 03 Aug 2010 10:28:25 -0500
Message-ID: <b066b9fc99d1b8e559ccbe58d8145d8d@localhost>
References: <1c7fae50481e2f053798107bf2ad2737@localhost> <alpine.DEB.1.10.1008030720540.19930@uplift.swm.pp.se> <20100803161456.31d0f69b@notabene> <20100803134658.4e48c97c@natsu> <20100803182950.01e13de0@notabene>
Reply-To: lists@nemebean.com
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100803182950.01e13de0@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Roman Mamedov <roman@rm.pp.ru>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 3 Aug 2010 18:29:50 +1000, Neil Brown <neilb@suse.de> wrote:
> On Tue, 3 Aug 2010 13:46:58 +0600
> Roman Mamedov <roman@rm.pp.ru> wrote:
> 
>> On Tue, 3 Aug 2010 16:14:56 +1000
>> Neil Brown <neilb@suse.de> wrote:
>> 
>> > > Yes, you can binary copy the drive like that, that's what I usually
>> > > do.
>> > 
>> > Of course you need to be sure that the old and new devices are
exactly
>> > the
>> > same size.  Normally they will but it is worth double checking that
the
>> > number of sectors (blockdev --getsize) is exactly the same.
>> 
>> Isn't it okay for the new drive to be larger? At least if the RAID0 was
>> created from partitions, not whole block devices.
>> And if it was created from devices, there is a way to make the new
larger
>> drive to be of exactly the same size as the old one, by setting a HPA
on
>> it
>> (see hdparm -N).
>> 
> 
> The thing that you include into the RAID0 must be the same size.  If
that
> is
> a partition, it is easy to make it the same size, but it is also easy to
> make
> it a different size - so care must be taken.
> If it is the whole device ... I wouldn't recommend using HPA - it would
> probably confused you later.  Just create a partition of exactly the
right
> size and use that.

Fortunately the arrays are built from partitions and not block devices,
and the one at the end of the disk is just /tmp so even if the new disk is
slightly smaller for some reason it won't be a big deal to lose that
particular array.  Now I just have to hope that the failing one lasts long
enough to pull the data off...

Thanks for all your help.

-Ben
