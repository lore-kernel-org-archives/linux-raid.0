From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: how to resize volume group lvm2?
Date: Fri, 12 Jun 2009 22:15:02 +0300
Message-ID: <20090612191502.GA29834@musti.tarvainen.info>
References: <20090610215835.GA4936@clouds> <4A303178.5060208@anonymous.org.uk> <20090612183339.GB4936@clouds> <20090612185841.GA14231@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090612185841.GA14231@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 12, 2009 at 08:58:41PM +0200, Michael Ole Olsen (gnu@gmx.net) wrote:

> How do I resize my volume group with lvm2?
> 
> vgextend needs new devices but I only have one device md0 for all my physical
> volumes.
> 
> I know how to resize my logical volumes under the volume group, but somehow
> the volume group st1500 did not extend after raid5 reshape with mdadm?

pvresize is the command you're looking for, I think.

-- 
Tapani Tarvainen
