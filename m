From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Locking bugs in 2.4 md.c
Date: Tue, 23 Sep 2003 13:08:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030923110836.GJ8670@marowsky-bree.de>
References: <20030918152310.GD30852@marowsky-bree.de> <16234.25885.855209.372799@notabene.cse.unsw.edu.au> <20030919072610.GB3143@marowsky-bree.de> <20030919083639.GE3143@marowsky-bree.de> <16238.36518.991915.293076@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16238.36518.991915.293076@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-09-22T15:54:46,
   Neil Brown <neilb@cse.unsw.edu.au> said:

> If you can show me a stack trace or some pointers to wher it panics, =
I
> can look further.

OK, it looks like the patch indeed fixes the locking races in md. The
other one I've been seeing was unrelated to md.

Though I did change the ITERATE_MDDEV/*_LOCK*/ in the the complete raid
state printout to the locked version.

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
