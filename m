From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: raid1 critical sections not protected in 2.4.x?
Date: Fri, 10 Oct 2003 10:14:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031010081445.GC29059@marowsky-bree.de>
References: <1065721318.4761.138.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1065721318.4761.138.camel@persist.az.mvista.com>
To: Steven Dake <sdake@mvista.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-09T10:41:59,
   Steven Dake <sdake@mvista.com> said:

> I have been looking at the raid1.c code.  There is a kernel thread
> raid1d that could be scheduled on processor A.  Then on processor B,
> other raid code could be scheduled as per each block I/O request.

Did you follow the recent locking fixes to md I discussed with Neil? I
think this fixes some of these; at least we have a confirmation from IB=
M
that some raid1 races (not resyncing after a hotadd, no progress during
resync etc) went away with it.


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
