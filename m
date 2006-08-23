From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID over Firewire
Date: Thu, 24 Aug 2006 09:28:16 +1200
Message-ID: <44ECC870.2090202@sauce.co.nz>
References: <44EB94BE.8080907@sauce.co.nz> <200608231510.26160.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200608231510.26160.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:

> Of all modes I wouldn't use a linear setup for backups. One disk dies - all 
> data is lost.

> I'd go for an external raid5 solution, tho those tend to be slow and 
> expensive.
> 

Unfortunately "budget" is the overriding factor here. Unlike RAID 0, I
thought there may be a way of recovering data from undamaged disks in a
linear array, although I guess the file system used has some say in this.

I hope to mitgate the risk somewhat by regularly using smartd to do long
self tests on the disks.

Regards,

Richard

