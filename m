From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: possible to use 1 drive as hot failover for 2 raid1's?
Date: Tue, 7 Oct 2003 12:54:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031007105437.GF28158@marowsky-bree.de>
References: <Pine.LNX.4.44.0310061625260.12382-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0310061625260.12382-100000@sasami.anime.net>
To: Dan Hollis <goemon@anime.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-06T16:27:59,
   Dan Hollis <goemon@anime.net> said:

> is it possible to use the single drive as hot-failover for both md0 a=
nd=20
> md1?

In theory yes, in practice not.

One could imagine (rather easily) a global hot-spare pool for all mds,
but it's not implemented right now.


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
