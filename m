From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Checking consistency of Linux software RAID
Date: Mon, 30 Jun 2003 15:36:47 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030630133647.GH12240@marowsky-bree.de>
References: <20030630131655.GE12240@marowsky-bree.de> <Pine.LNX.4.43.0306301425030.31613-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.43.0306301425030.31613-100000@unicorn.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-06-30T14:28:57,
   Gordon Henderson <gordon@drogon.net> said:

> You are pedantically correct, but in the absence of anything else, at
> least it could form a partial solution and let him know that a proble=
m
> exists which could them be actioned in some way before it becomes dat=
a
> threatening.

No. The problem is that if badblocks returns anything on a md device,
the data _is_ already threatened beyond rescue.

A badblocks r/o test on the underlaying devices me be more sensible and
help to diagnose it a little, but it also won't verify consistency
between the drives.


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
