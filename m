From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 09:00:25 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>
References: <20040731174002.GA9738@middle.of.nowhere>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040731174002.GA9738@middle.of.nowhere>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 31 Jul 2004, Jurriaan wrote:

> > So why are scsi raid-5 systems so much better?
> 
> compared to other scsi raid-arrays, they are not 'better' for small
> random writes. If they are better than ide, it's probably because of the
> smaller access times for 15k rpm drives.

And also because scsi drives can do tagged queueing which makes it more 
efficient to do a lot of smaller operations. Historically the SCSI drives 
also had more cache memory which helps the situation, and the scsi 
RAID controllers probably also had more cache memory on them (I know RAID 
systems that have gigabytes of cache memory).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

