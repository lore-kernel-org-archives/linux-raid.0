From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 write order fidelity
Date: Fri, 1 Aug 2008 10:26:48 +1000
Message-ID: <18578.22600.936623.203944@notabene.brown>
References: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
	<4891ED2F.30301@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Thursday July 31
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: aristizb@ualberta.ca, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 31, david@dgreaves.com wrote:
> aristizb@ualberta.ca wrote:
> > Hi,
> > 
> > I am currently working with a software Linux RAID1, with external bitmap
> > and no write-behind option. Does the RAID controller keep the write
> > order fidelity?.

md/RAID1 provides the same guarantees as the underlying device, which
usually isn't much of a guarantee.

> > 
> > If an application writes some blocks on the RAID device in a particular
> > order, can I ensure that these blocks will be written to the devices
> > conforming the RAID on the same order, or at least on the main disk?
> > (disk 0 on the RAID).
> 
> I suspect you need to do some research on 'barriers'.
> 
> I think the answer at present is 'no'.
> 
> Hence messages like:
> Filesystem "md0": Disabling barriers, not supported by the underlying device

A strange message to get as md/RAID1 *does* support barriers when all the
underlying devices do (since the mid-teens of 2.6 I think).

NeilBrown
