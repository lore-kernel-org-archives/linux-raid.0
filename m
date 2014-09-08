From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID0 size over 2 TB
Date: Mon, 8 Sep 2014 12:27:47 -0600
Message-ID: <D920D060-0CEC-4B6E-B636-4671B6FDC156@colorremedies.com>
References: <20140906230928.BB645CEE@pobox.sk>, <20140908170037.451e2376@notabene.brown>, <20140908091811.1DD1140C@pobox.sk> <20140908172832.7543b241@notabene.brown> <20140908093351.382B7496@pobox.sk>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908093351.382B7496@pobox.sk>
Sender: linux-raid-owner@vger.kernel.org
To: azurIt <azurit@pobox.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sep 8, 2014, at 1:33 AM, azurIt <azurit@pobox.sk> wrote:
> 
> This is really strange, here is what cgdisk is reporting:
> http://imgur.com/U8VnAdM

Does your kernel have CONFIG_EFI_PARTITION=y ?

Old versions of fdisk report the protective MBR, it does not show you GPT partition map. It's normal for the protective MBR to max out out 2TB because MBR encodes 32-bit 512 byte sectors on 512e devices. Your kernel appears to think the disk is 2TB, which suggests to me it's looking only at the MBR, meaning it doesn't have GPT support turned on.


Chris Murphy