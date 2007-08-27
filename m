From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid10 or raid1+0 ?
Date: Mon, 27 Aug 2007 10:27:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708271025190.23403@p34.internal.lan>
References: <46D21D73.9060100@digithi.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1615902645-1188224851=:23403"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46D21D73.9060100@digithi.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?=22T=2E_Eichst=E4dt=22?= <abc@digithi.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1615902645-1188224851=:23403
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 27 Aug 2007, "T. Eichst=E4dt" wrote:

> Hallo all,
>
> I have 4 HDDs and I want to use mirroring and striping.
> I am wondering what difference between the following two solutions is:
>
> - raid0 on top of 2 raid1 devices (raid1+0)
> - directly using the raid10 module
>
> Perhaps someone can give me a hint what the raid10 linux module does in=
=20
> difference to the combination of raid1 and raid0.
>
> Another question:
> How stable is the raid10 module in the linux kernel. I am currently using=
 the=20
> debian kernel 2.6.18 but I saw some patches from Neil and others for 2.6.=
21,=20
> 2.6.22 regarding the raid10 module. And their descriptions sound as if it=
=20
> could be useful to integrate them. when using raid10.
> Okay, backporting isn't complicated, but nevertheless the number of patch=
es=20
> makes me feel that raid10 is perhaps not that stable like raid0 and raid1=
 ???
>
> Perhaps someone can blow away my fear :)
>
> Best regards
> Thimo Eichst=E4dt
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I have a few people who asked me this as well, RAID10 or similiar (SW).  I=
=20
am not so sure, with RAID1 you can have your root disks on it and boot=20
from it using LILO/GRUB and it is proven pretty stable; can the same be=20
said about RAID10?
---1463747160-1615902645-1188224851=:23403--
