From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: md: bug in file md.c, line 1440 (2.4.22)
Date: Wed, 3 Sep 2003 10:57:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030903085735.GB5762@marowsky-bree.de>
References: <3F5017CA.4080700@tomt.net> <16213.14893.955734.797630@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16213.14893.955734.797630@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>, Andre Tomt <andre@tomt.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mingo@redhat.com
List-Id: linux-raid.ids

On 2003-09-03T10:47:41,
   Neil Brown <neilb@cse.unsw.edu.au> said:

> I have not idea how it got the failed flag.

What's proven very helpful to figure out these things is to run a
test script against md, and just trying all the various possible action=
s
via mdadm or raidtools randomly.

I've done that for m-p, and while it's not pretty, it is _really_
helpful and has found all sorts of weird accounting bugs in the md code
(2.4 has many): ftp://ftp.suse.com/pub/people/lmb/md-mp/mp-test.sh - if
anyone feels like extending it to include raid5/raid1 etc, that would b=
e
cool ;-)



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
