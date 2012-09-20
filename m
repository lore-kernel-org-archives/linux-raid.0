From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Wed, 19 Sep 2012 20:39:55 -0600
Message-ID: <7577D4C6-344F-4AE6-BB6A-3B4F29D4CAA0@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4961154.0TR9MeFlIq@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 19, 2012, at 5:03 AM, G=FCnther J. Niederwimmer wrote:

> Hello,
>=20
> can any tell me, why the GPT Table is broken by a linux installation

What format superblock? I will guess it's 1.0 which stores the superblo=
ck at the end of the disk and may be stepping on the secondary GPT head=
er. And then when you repair the GPT, you're wiping out part of the md =
superblock so it breaks your RAID.

It's confusing that the GPT table is created with diskpart, instead of =
parted.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
