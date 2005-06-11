From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_nv and RAID1
Date: Sat, 11 Jun 2005 20:26:06 +0100
Message-ID: <20050611192606.GA4055@pentafluge.infradead.org>
References: <200506111613.42962.dvadell@lantech.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200506111613.42962.dvadell@lantech.com.ar>
Sender: linux-raid-owner@vger.kernel.org
To: "Diego M. Vadell" <dvadell@lantech.com.ar>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jun 11, 2005 at 04:13:42PM +0000, Diego M. Vadell wrote:
> Hi,
>    A new computer arrived at work with 4 160GB SATA disks. I made a
> couple of RAID 1 (mirror) with two disks each, and then joined them wih
> LVM. Now I have 320GB in my root volume.
> 
> My boss asked me to test it, so we all gathered and unplugged the data
> cable of one of the disks. I was hoping to see linux making warnings for

Hotplug is not supported yet.  Don't do that :)

	Jeff



