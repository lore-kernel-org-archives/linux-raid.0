From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: Measuring RAID-0 CPU load
Date: Mon, 08 Mar 2004 18:19:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1x1xo3w92j.fsf@kth.se>
References: <404CAA28.6030502@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ian Pilcher <i.pilcher@comcast.net> writes:

> I need to quantify the additional CPU load that RAID-0 adds (vs. the
> boost in I/O performance).  I don't need to do anything fancy;
> 'dd if=3D/dev/zero of=3D/dev/md?" should do the trick, but I'm not su=
re how
> to track the processor utilization during the run.
>
> Any ideas?

top not good?

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
