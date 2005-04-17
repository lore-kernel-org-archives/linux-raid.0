From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: waiting for recovery to complete
Date: Sun, 17 Apr 2005 10:49:14 -0700
Message-ID: <4262A19A.9010909@nsr500.net>
References: <20050413085056.GP21278@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050413085056.GP21278@eychenne.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The recovery daemon adjusts reconstruction speed dynamically according =
to=20
available system resources.

Disk I/O is somewhat slower but works just fine.  You don't have to wai=
t.


Herv=E9 Eychenne wrote:
>  Hi,
>=20
> Suppose I'm waiting for a recovery to be completed, and want to run a
> command afterwards (halt, send a mail, or anything else...).
> The most practiacl way I can see is to check /proc/mdstat.
>=20
> But what if I want to do that automatically (without bothering lookin=
g
> at it manually from time to time)?
> For example, one could do:
> # while cat /proc/mdstat | grep recovery > /dev/null ; do sleep 5 ; d=
one
>=20
> But that's quite ugly, as:
> - it's an active polling, and it is time consuming (even if slightly)
> - it may even be unreliable, as I guess one cannot ensure that /proc/=
mdstat
>   will print the "recovery" string during the (very short, but well..=
=2E)
>   transition between two partitions to recover
>=20
> I think that a passive wait would be much better instead.
> And ideally, we should have a simple and efficient way to let a progr=
am
> know if a device is in a clean state (or being recovered), and anothe=
r
> that would wait until the device is clean (recovery finished).
>=20
> So, the while loop could be replaced by something like
>  mdadm --recovery-wait    (for example)
> which would exit only when all pending recoveries have finished, and
> let the script continue.
> That would be much practical, reliable, and cleaner than a loop, don'=
t you
> think?
>=20
> How this could be achieved is another question... probably the best
> would be that userspace can select on a file descriptor, or something
> like that (netlink device?)
> What do you think?
>=20
>  Herv=E9
>=20

--=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
