From: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: HW Raid Question
Date: Mon, 19 Oct 2009 12:18:31 +0200
Message-ID: <b95c1fdd0910190318s25a8e630l4dcc27eaa291f2ba@mail.gmail.com>
References: <c268e4660909272103r3831e129m68c11899b11be222@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909272103r3831e129m68c11899b11be222@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/9/28 Drew <drew.kay@gmail.com>:
> I know this isn't exactly a linux SW RAID question but I've exhausted
> every place I can think of for an answer and you folks know your raid
> so here goes.
>
> Do IBM's ServeRAID (rebranded Adaptec) controllers support growing a
> online/active RAID array by replacing component disks with larger
> ones? I've done this often enough with mdadm on my home servers but a=
t
> work we use IBM servers so I'm stuck.
>

Hi, Drew,

You cannot grow an array on ServeRAID by replacing smaller drives with
bigger ones. If you do such a replacement the drive size will be
"clipped". That means if you have 5x36 GB drive, remove one, and put
in a 140 GB drive, only 36 GB out of it will be used. I'm pretty sure
this will also happen if you try to extend the array by adding bigger
drives to the already existing array.

The only way is to tear the array down and re-define it with bigger dri=
ves.

Regards,
Pawe=B3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
