From: Derek Vadala <derek@cynicism.com>
Subject: Re: raidtools-20010914
Date: Thu, 19 Dec 2002 08:51:17 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021219135117.470063B807@jaded.cynicism.com>
References: <3E01CBD8.6A18B88F@softers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E01CBD8.6A18B88F@softers.net>
To: linux-raid@vger.kernel.org
Cc: =?X-UNKNOWN?Q?Jarmo_J=E4rvenp=E4=E4?= <Jarmo.Jarvenpaa@softers.net>
List-Id: linux-raid.ids

On Thu, 19 Dec 2002, Jarmo [iso-8859-1] J=E4rvenp=E4=E4 wrote:

> - 3 RAID 1 devices with each having 2 partitions mirrored together.
> - Kernel 2.4.20

There are some known issues with this release of raidtools. Avoid using
it. Either revert to the previous version, or move up to 1.0 (available=
 as
a REdHat 8.0 rpm or source rpm). Does anyone know if the tar file for
raidtools-1.0 is floating around yet?

Don't use raidhotgenerateerror. Use raidsetfaulty to mark a disk as
failed.

Or, use mdadm.


--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
