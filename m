From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: Any way to test mdadm email alerts?
Date: Thu, 29 Jan 2004 16:12:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xznc6iyam.fsf@kth.se>
References: <dd.233e849.2d4a77e1@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

AndyLiebman@aol.com writes:

> Does anybody know if it's possible to test mdadm email alerts? Is
> there a way to see if the system really will send an alert of
> there's a problem (other than creating a problem and watching for an
> email)?

Manually marking a disk as failed should trigger an email, but maybe
that counts as creating a problem.

> Also, does anyone know if it's possible to use Mozilla Mail or KMail
> (part of KDE) as the program that sends the mail, instead of using
> Sendmail (which seems terribly complicated to configure just for
> sending alerts).

You can't.  You can install postfix instead of sendmail.  The
configuration of postfix is a little less cryptic.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
