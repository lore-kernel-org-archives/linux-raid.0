From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: How robust is MD/multipath????
Date: Mon, 29 Sep 2003 11:27:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030929092758.GC16928@marowsky-bree.de>
References: <sf75d847.068@gw.state.sc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <sf75d847.068@gw.state.sc.us>
To: Doug Griswold <griswld@cio.sc.gov>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-09-27T18:34:39,
   Doug Griswold <griswld@cio.sc.gov> said:

> Just wondering if I use multipath for failover on our SAN
> if I should expect any problems, ie performance/stability.

We are quite happy with 2.4 md multipath + my patch set from
ftp://ftp.suse.com/pub/people/lmb/md-mp/. 2.6 I've not tested yet at
all.


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
