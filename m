From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports Raid Level Migration and Online Capacity Expansion
Date: Thu, 29 Dec 2005 10:20:13 -0800 (PST)
Message-ID: <dp19ct$sc6$1@terminus.zytor.com>
References: <20051222100703.23157.qmail@web52909.mail.yahoo.com> <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <62b0912f0512220431l4d1ec130q137b737c1956ddd9@mail.gmail.com>
By author:    Molle Bestefich <molle.bestefich@gmail.com>
In newsgroup: linux.dev.raid
> 
> MD is a little more difficult to set up and also lacks in that it
> doesn't integrate with BIOS level stuff and boot loaders (maybe
> there's minimal MD RAID 1 support in Lilo, not sure).  Depending on
> your choice of hardware, you might also get more features than MD can
> currently offer.
> 

LILO and SYSLINUX/EXTLINUX can boot from RAID-1; some versions of GRUB can too.

	-hpa
