From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: raid1 critical sections not protected in 2.4.x?
Date: Tue, 14 Oct 2003 09:13:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031014071355.GC1951@marowsky-bree.de>
References: <1065721318.4761.138.camel@persist.az.mvista.com> <20031010081445.GC29059@marowsky-bree.de> <1066080570.4761.233.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1066080570.4761.233.camel@persist.az.mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-13T14:29:30,
   Steven Dake <sdake@mvista.com> said:

> Could you provide a pointer to those md locking fixes?

I'm on a train right now :), but I believe I put a copy of the most
recent version at ftp://ftp.suse.com/pub/people/lmb/md/md-locking. If
not, I'll put them there as soon as possible ;-)

Neil is currently travelling too, so he hadn't had time to review it
yet. My version deviates from his to fix some races which we found.

There's some more work I think needs doing, namely moving all of the md
global structs and arrays into a single struct md_whatever[] for
tidyness, but I'm not sure whether I still want to touch the 2.4 code a=
t
all ;-)


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
