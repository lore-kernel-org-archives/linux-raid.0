From: "Doug Griswold" <griswld@cio.sc.gov>
Subject: Re: How robust is MD/multipath????
Date: Mon, 29 Sep 2003 08:16:15 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <sf77ea5d.082@gw.state.sc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: lmb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How about without the patch?  I'm using rh as2.1 so if I recompile I
will lose support if ever needed.  Is the red hat md/multipath
production ready???

>>> Lars Marowsky-Bree <lmb@suse.de> 09/29/03 05:27AM >>>
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
High Availability & Clustering		ever tried. ever failed. no
matter.
SuSE Labs				try again. fail again. fail
better.
Research & Development, SUSE LINUX AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
the body of a message to majordomo@vger.kernel.org=20
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
