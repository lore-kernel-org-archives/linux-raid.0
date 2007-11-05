From: David Greaves <david@dgreaves.com>
Subject: Re: Kernel Module - Raid
Date: Mon, 05 Nov 2007 20:48:57 +0000
Message-ID: <472F81B9.2070100@dgreaves.com>
References: <472F7AED.1030207@bradfordnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472F7AED.1030207@bradfordnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul VanGundy <pvangundy@bradfordnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul VanGundy wrote:
> All,
>=20
> Hello. I don't know if this is the right place to post this issue but=
 it
> does deal with RAID so I thought I would try.
It deals primarily with linux *software* raid.
But stick with it - you may end up doing that...

What hardware/distro etc are you using?
Is this an expensive (hundreds of =A3) card? Or an onboard/motherboard =
chipset?

Once you answer this then it may be worth suggesting using sw-raid (in =
which
case we can help out) or pointing you elsewhere...

> I successfully built a new kernel and am able to boot from it.
> However, I need to incorporate a specific RAID driver (adpahci.ko) so=
 we
> can use the on-board RAID.
I think this is the adaptec proprietary code - in which case you may ne=
ed a very
specific kernel to run it. You may find others on here who can help but=
 you'll
probably need an Adaptec forum/list.

> I have the adpahci.ko and am unable to get
> it to compile against any other kernel because I don't have the origi=
nal
> kernel module (adpahci.c I assume is what I need). Is there any way I
> can view the adpahci.ko and copy the contents to make a adpahci.c?
No

> Is it
> possible to get the kernel object to compile with another kernel only
> using the adpahci.ko?
No

> Am I making sense?  :)
Yes

That's one of the big reasons proprietary drivers suck on linux.

David

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
