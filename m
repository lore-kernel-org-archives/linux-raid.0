From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Locking bugs in 2.4 md.c
Date: Fri, 19 Sep 2003 10:36:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030919083639.GE3143@marowsky-bree.de>
References: <20030918152310.GD30852@marowsky-bree.de> <16234.25885.855209.372799@notabene.cse.unsw.edu.au> <20030919072610.GB3143@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030919072610.GB3143@marowsky-bree.de>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, axboe@suse.de
List-Id: linux-raid.ids

On 2003-09-19T09:26:10,
   Lars Marowsky-Bree <lmb@suse.de> said:

> > A patch against 2.4-current is below.  It probably works but I have=
n't
> > reviewed it in the context of other recent changes to md so I make =
no
> > promises.
> Thanks. I'll merge it against the current 2.4.

Hi Neil, turns out your patch did exactly what I did with lock_mddev(),
just with a bigger granularity (which I think is a good thing, but I wa=
s
too shy to introduce a new lock).

However, I can still reliably panic the kernel with the sequence I gave
on a SMP box, even though the panic now seems to occur in different
places...

So if you have any further idea what could cause that, I appreciate any
hints ;-)

I'll go dig in some deeper now and gear up kgdb...


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
