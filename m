From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Replacing a drive in RAID 0
Date: Tue, 3 Aug 2010 07:22:01 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1008030720540.19930@uplift.swm.pp.se>
References: <1c7fae50481e2f053798107bf2ad2737@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1c7fae50481e2f053798107bf2ad2737@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Nemec <lists@nemebean.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Aug 2010, Ben Nemec wrote:

> enough to do that, of course).  Can I just dd the entire drive over and
> replace the bad drive?  Can the md tools do it somehow?  Maybe it's

Yes, you can binary copy the drive like that, that's what I usually do.

Use dd_rescue (or ddrescue, they are two different utils) instead of dd in 
case you have any bad blocks.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
