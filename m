From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: mdadm and email warnings
Date: Wed, 28 Jan 2004 21:13:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xn0876dcx.fsf@kth.se>
References: <db.225a512.2d4965fb@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

AndyLiebman@aol.com writes:

> Can anybody point me to information/how-tos that describe,
> step-by-step, how to configure mdadm to give me warnings about
> possible problems with my raid arrays? I realize that mdadm can
> monitor the status of the raids and send me a warning if something
> looks bad. But I'm fuzzy on how exactly to set this up.  Sorry, but
> the details aren't obvious from any of the manuals or help files.
>
> For instance, I see that I can enter an email address with the flag
> -m and the address. But do I need to specify a program that will
> send that email? It looks that way to me. Can I use KDE Mail to do
> the job? Or do I need to use something that doesn't involve a GUI?

I run "mdadm --monitor --scan --daemonise" and have put a mail address
in mdadm.conf.  Make sure sendmail or something compatible
(e.g. postfix) is installed.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
