From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: How safe is software RAID compared to how safe hardware RAID is!?
Date: Wed, 19 Nov 2003 00:04:54 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOOEIDGOAA.jim@jimtreats.com>
References: <200311191051.48540.franc@tech.sirca.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200311191051.48540.franc@tech.sirca.org.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for everyones replies.. that's given me a real feel for how its =
being
used by you guys..

I've gone through a week of discovery and should the need arise i will
certainly look into it even more.. hopefully i've gone far enough that =
for
the near future *touch wood* i'll be at that "it just works" stage, and=
 the
next linux learning step can be mine to frustrate me :)

Having had problems with the device i will be testing it a lot over the=
 next
few days/weeks.. i'm comforted by the array staying up in the event of =
a
drive failure.. I'm a little worried that I am not going to spot a driv=
e
fail.. I guess thats what the mdadm monitor stuff is for!?!? if i run t=
his
once will it work forever or just until i power down?!

Its also reassuring that during my wrestling with the corruption proble=
ms i
was having i discovered that whilst not ideal you can mount the constit=
uent
mirror raid drives seperately and deal with them... this perhaps gives =
me
something that i can fall back on although the normal array should be o=
nline
anyways so its kind of redundant.. if need be i can make a backup of my
backup of those ULTRA important files before attempting to rebuild the
array...

Thanks again... The only thing that i was kind of justifying paying =A3=
100 and
above on for the 3ware cards was that it claimed to be able to get SMAR=
T
info off my hdds.. i don't know if the promise ultra 100 ATA controller=
 does
this.. and i'm not sure how you get SMART/temperature information out o=
f
drives in linux anyways.. I will go searching for that... with a new ca=
se
ordered though my backup machine should be sufficiently cooled

Cheers

Jim

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
