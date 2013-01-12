From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sat, 12 Jan 2013 08:14:04 -0600
Message-ID: <50F16FAC.7000509@hardwarefreak.com>
References: <2258826.8.1357992379424.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2258826.8.1357992379424.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/12/2013 6:06 AM, Roy Sigurd Karlsbakk wrote:
>> Unlikely to make up the difference is the scheduler. Parallel fs's
>> like XFS don't perform nearly as well with CFQ, so you should have a
>> kernel parameter elevator=3Dnoop.
>=20
> uh=85 how can the filesystem chosen be relevant to the disk elevator?=
=20

It's the other way round.  The chosen elevator can cause problems with
the filesystem.  You should find this relevant conversation amongst the
lead XFS developers educational:

http://oss.sgi.com/archives/xfs/2011-07/msg00464.html

> CFQ will try to optimize access to reduce seeks

"Completely Fair Queuing" -- The name alone tells you how it works.  It
most certainly does not do what you state.  Please read the brief
Wikipedia article:  http://en.wikipedia.org/wiki/CFQ

> and should be completely independent on the filesystem used on top.

Operative word: "should"

The USA should not be $16 Trillion in debt, but it is.  By internationa=
l
law whales should not be killed, but they still are.  Etc.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
