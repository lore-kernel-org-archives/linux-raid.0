From: <me@heyjay.com>
Subject: Re: Sync rates?
Date: Thu, 6 May 2004 14:50:31 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00cb01c433a3$64865eb0$6705a8c0@a30>
References: <00a401c4339e$7f86b340$6705a8c0@a30> <yw1xsmede4hk.fsf@kth.se> <409A94BD.40207@steeleye.com>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----=20
=46rom: "Paul Clements" <paul.clements@steeleye.com>
To: <linux-raid@vger.kernel.org>
Sent: Thursday, May 06, 2004 2:40 PM
Subject: Re: Sync rates?


M=E5ns Rullg=E5rd wrote:
> <me@heyjay.com> writes:

>>will be done syncing in just under 24 hours.  Is this sync rate expec=
ted?
I

Have you checked /proc/sys/dev/raid/speed_limit_min and _max ? These ma=
y
need to be increased if you want the resync to be faster.
------


platinum:~# cat /proc/sys/dev/raid/speed_limit_min
1000
platinum:~# cat /proc/sys/dev/raid/speed_limit_max
200000

Are these acceptable?

Jay

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
