From: Steven Dake <sdake@mvista.com>
Subject: Re: raid1 critical sections not protected in 2.4.x?
Date: Mon, 13 Oct 2003 14:29:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1066080570.4761.233.camel@persist.az.mvista.com>
References: <1065721318.4761.138.camel@persist.az.mvista.com>
	 <20031010081445.GC29059@marowsky-bree.de>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031010081445.GC29059@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Could you provide a pointer to those md locking fixes?

Thanks!
-steve

On Fri, 2003-10-10 at 01:14, Lars Marowsky-Bree wrote:
> On 2003-10-09T10:41:59,
>    Steven Dake <sdake@mvista.com> said:
>=20
> > I have been looking at the raid1.c code.  There is a kernel thread
> > raid1d that could be scheduled on processor A.  Then on processor B=
,
> > other raid code could be scheduled as per each block I/O request.
>=20
> Did you follow the recent locking fixes to md I discussed with Neil? =
I
> think this fixes some of these; at least we have a confirmation from =
IBM
> that some raid1 races (not resyncing after a hotadd, no progress duri=
ng
> resync etc) went away with it.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=C3=A9e <lmb@suse.de>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
