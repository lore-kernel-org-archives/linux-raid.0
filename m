From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Locking bugs in 2.4 md.c
Date: Fri, 19 Sep 2003 09:26:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030919072610.GB3143@marowsky-bree.de>
References: <20030918152310.GD30852@marowsky-bree.de> <16234.25885.855209.372799@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16234.25885.855209.372799@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, axboe@suse.de
List-Id: linux-raid.ids

On 2003-09-19T12:08:29,
   Neil Brown <neilb@cse.unsw.edu.au> said:

> A patch against 2.4-current is below.  It probably works but I haven'=
t
> reviewed it in the context of other recent changes to md so I make no
> promises.

Thanks. I'll merge it against the current 2.4.

I had already started putting lock_/unlock_mddev() statements through
potential candidates, but that didn't actually help. raid1d was racy
with md_update_sb somehow, and I couldn't figure out how ;-)

A global lock may indeed be better.

I'll let you know how it goes.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SuSE Linux AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
