From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: XP RAID vs md
Date: Wed, 2 Apr 2003 17:27:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030402152731.GE7364@marowsky-bree.de>
References: <3E8AD562.6090707@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E8AD562.6090707@webmail.co.za>
To: Vladimir Milovanovic <vlad@webmail.co.za>, raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2003-04-02T14:19:46,
   Vladimir Milovanovic <vlad@webmail.co.za> said:

> Wow... I hope that one of the maintainers will comment on this, I did=
n't=20
> even know that XP had a sw RAID implementation. Up to 100% more on re=
ad=20
> and 60% more on write is quite a significant margin. Is there anythin=
g=20
> in favour of the md driver if this is true?

I've not really checked these numbers yet, so take the following with a=
 grain
of salt.

However, with RAID1 for example, I got approximately twice the read spe=
ed and
95% of the write speed (compared to just using a single disk).

I have a really hard time imagining a 100% read boost; that would simpl=
y
exceed disk bandwidth, and 60% writes - how should that work?

I'm not claiming md is perfect or the fastest imaginable solution, but =
it is
rather close to theoretical disk bandwidth. A two digit percentage perf=
ormance
improvement just can't be done.



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
