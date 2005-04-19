From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@eychenne.org>
Subject: Re: waiting for recovery to complete
Date: Tue, 19 Apr 2005 12:28:10 +0200
Message-ID: <20050419102810.GH3103@eychenne.org>
References: <20050413085056.GP21278@eychenne.org> <4262A19A.9010909@nsr500.net>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4262A19A.9010909@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 17, 2005 at 10:49:14AM -0700, Tim Moore wrote:

 Hi,

> The recovery daemon adjusts reconstruction speed dynamically accordin=
g to=20
> available system resources.
> Disk I/O is somewhat slower but works just fine.  You don't have to w=
ait.

So I don't have to wait to take the disk out, as the recovery will
continue with embedded disk battery and wireless bus connection?
How cool... ;-)

Well... more seriously, I can't believe this question doesn't raise
any interest, even if it seems like it does not. :-(
Does everyone really type cat /proc/mdstat from time to time??
How clumsy...
I just want to chat about the best way to add a backend for this kind
of feature, so we could implement that properly... (and yes, that is
definitely _nedded_ if you want to do things right)

 Herve

> Herv=E9 Eychenne wrote:
> > Hi,
> >
> >Suppose I'm waiting for a recovery to be completed, and want to run =
a
> >command afterwards (halt, send a mail, or anything else...).
> >The most practiacl way I can see is to check /proc/mdstat.
> >
> >But what if I want to do that automatically (without bothering looki=
ng
> >at it manually from time to time)?
> >For example, one could do:
> ># while cat /proc/mdstat | grep recovery > /dev/null ; do sleep 5 ; =
done
> >
> >But that's quite ugly, as:
> >- it's an active polling, and it is time consuming (even if slightly=
)
> >- it may even be unreliable, as I guess one cannot ensure that /proc=
/mdstat
> >  will print the "recovery" string during the (very short, but well.=
=2E.)
> >  transition between two partitions to recover
> >
> >I think that a passive wait would be much better instead.
> >And ideally, we should have a simple and efficient way to let a prog=
ram
> >know if a device is in a clean state (or being recovered), and anoth=
er
> >that would wait until the device is clean (recovery finished).
> >
> >So, the while loop could be replaced by something like
> > mdadm --recovery-wait    (for example)
> >which would exit only when all pending recoveries have finished, and
> >let the script continue.
> >That would be much practical, reliable, and cleaner than a loop, don=
't you
> >think?
> >
> >How this could be achieved is another question... probably the best
> >would be that userspace can select on a file descriptor, or somethin=
g
> >like that (netlink device?)
> >What do you think?
> >
> > Herv=E9

 Herv=E9

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)  Homepage:          http://www.eychenne.org/
v_/_ WallFire project:  http://www.wallfire.org/

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
