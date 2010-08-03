From: Neil Brown <neilb@suse.de>
Subject: Re: Replacing a drive in RAID 0
Date: Tue, 3 Aug 2010 18:29:50 +1000
Message-ID: <20100803182950.01e13de0@notabene>
References: <1c7fae50481e2f053798107bf2ad2737@localhost>
	<alpine.DEB.1.10.1008030720540.19930@uplift.swm.pp.se>
	<20100803161456.31d0f69b@notabene>
	<20100803134658.4e48c97c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100803134658.4e48c97c@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Ben Nemec <lists@nemebean.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Aug 2010 13:46:58 +0600
Roman Mamedov <roman@rm.pp.ru> wrote:

> On Tue, 3 Aug 2010 16:14:56 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > > Yes, you can binary copy the drive like that, that's what I usually do.
> > 
> > Of course you need to be sure that the old and new devices are exactly the
> > same size.  Normally they will but it is worth double checking that the
> > number of sectors (blockdev --getsize) is exactly the same.
> 
> Isn't it okay for the new drive to be larger? At least if the RAID0 was
> created from partitions, not whole block devices.
> And if it was created from devices, there is a way to make the new larger
> drive to be of exactly the same size as the old one, by setting a HPA on it
> (see hdparm -N).
> 

The thing that you include into the RAID0 must be the same size.  If that is
a partition, it is easy to make it the same size, but it is also easy to make
it a different size - so care must be taken.
If it is the whole device ... I wouldn't recommend using HPA - it would
probably confused you later.  Just create a partition of exactly the right
size and use that.

NeilBrown
