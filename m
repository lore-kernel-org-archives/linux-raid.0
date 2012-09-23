From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Sun, 23 Sep 2012 01:17:43 -0600
Message-ID: <8CD3CA16-FC0C-462E-BAA5-70F993300867@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <1718683.C0AtuyUDq1@techz> <FF5F85AF-C7AA-4EA0-9871-26A87A28690F@colorremedies.com> <1822898.lj0EyHG9Nm@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1822898.lj0EyHG9Nm@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 23, 2012, at 12:47 AM, G=FCnther J. Niederwimmer wrote:

> OK, the system is running but never start parted or a other tool and =
say to=20
> anything yes, then you have a destroyed system :(

This will not destroy anything

parted -l

or

gdisk -l /dev/sda
gdisk -l /dev/sdb

I think those disks have latent GPTs on them and that's the source of t=
he (likely ignorable) problem.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
