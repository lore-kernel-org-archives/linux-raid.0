From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 17:39:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030627153935.GR7800@marowsky-bree.de>
References: <Pine.LNX.4.55.0306270920010.6883@datavibe.net> <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.43.0306271429480.32150-100000@unicorn.drogon.net>
To: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-06-27T14:43:23,
   Gordon Henderson <gordon@drogon.net> said:

> > project I'm working on at the moment.  It's either an older card, o=
r
> > software RAID1 (and, with all due respect, I don't want to use linu=
x
> > software raid in -this sort- of production environment).
> Er.. Why not?

Because the software RAID doesn't take care of problems like hotswap fo=
r
one.

That's about the only compelling reason for specialized hardware I can
really think of, but it's a good one.


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
