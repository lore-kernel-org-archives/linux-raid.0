From: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH] Linux Raid5/6 abover 2 Terabytes
Date: Wed, 07 Apr 2004 01:02:03 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <jey8p8ww0k.fsf@sykes.suse.de>
References: <1081285240.2219.43.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1081285240.2219.43.camel@e-linux> (Evan Felix's message of
 "Tue, 06 Apr 2004 14:00:40 -0700")
To: Evan Felix <evan.felix@pnl.gov>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Evan Felix <evan.felix@pnl.gov> writes:

> Here is a patch that fixes a major issue in the raid5/6 code.  It see=
ms
> that the code:
>
> logical_sector =3D bi->bi_sector & ~(STRIPE_SECTORS-1);
> (sector_t)     =3D (sector_t)    & (constant)
>
> that the right side of the & does not get extended correctly when the
> constant is promoted to the sector_t type.  I have CONFIG_LBD turned =
on
> so sector_t should be 64bits wide.  This fails to properly mask the
> value of 4294967296 (2TB/512) to 4294967296.  in my case it was comin=
g
> out 0.  this cause the loop following this code to read from 0 to
> 4294967296 blocks so it could write one character.
>
> As you might imagine this makes a format of a 3.5TB filesystem take a
> very long time.
>
> Here is the patch:

Alternatively replace ~(STRIPE_SECTORS-1) by -STRIPE_SECTORS, which
doesn't need a cast.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux AG, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
Key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
