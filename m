From: Drew <drew.kay@gmail.com>
Subject: Re: Direct disk access on IBM Server
Date: Sun, 24 Apr 2011 05:48:36 -0700
Message-ID: <BANLkTi=SRxoMjpEHeS48eJBCt3qY8CMYqQ@mail.gmail.com>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com>
 <iomfkq$qqr$1@dough.gmane.org> <4DAEC627.3030904@grumpydevil.homelinux.org>
 <iomj0a$e5m$1@dough.gmane.org> <4DAFCDB0.9070609@hardwarefreak.com> <iop4s2$cjp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iop4s2$cjp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

> My goal here is to understand my options before deciding. =C2=A0I've =
had a bit of
> space between getting the machine and actually having the time to put=
 it
> into service, so I've tested a bit and thought a bit and discussed a =
bit on
> this mailing list. =C2=A0I'll probably go for hardware raid5 - which =
I could have
> done in the beginning. =C2=A0But now I know more about why that's the=
 sensible
> choice.

I'm going to jump in a bit late but as an owner of several of these
little beasts and say this. You have a skookum RAID card on there so
use it. :) I'd also *strongly* recommend you jump for the BBU
(Battery) if you haven't already.

This hasn't been mentioned as a consideration but one more point of
going in favor with the HW RAID is this: You're away on vacation and a
drive dies. Your backup admin notices and calls an IBM monkey out to
replace the drive. He goes, finds the failed drive indicated by the
little warning light, and replaces it. You get back to find a zero
dollar service order on your desk. :-)

I don't know about your shop but that's how it'd play out in mine.
mdadm is a great product no doubt, but to work effectively with it
everyone involved has to understand it. If you're a one man show like
I am, with vendors who don't really touch linux (not as much money in
it vs M$), making your linux systems as foolproof as possible is
important, especially when the bosses are somewhat biased against it.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
