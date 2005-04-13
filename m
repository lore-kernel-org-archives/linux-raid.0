From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@eychenne.org>
Subject: waiting for recovery to complete
Date: Wed, 13 Apr 2005 10:50:56 +0200
Message-ID: <20050413085056.GP21278@eychenne.org>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Hi,

Suppose I'm waiting for a recovery to be completed, and want to run a
command afterwards (halt, send a mail, or anything else...).
The most practiacl way I can see is to check /proc/mdstat.

But what if I want to do that automatically (without bothering looking
at it manually from time to time)?
=46or example, one could do:
# while cat /proc/mdstat | grep recovery > /dev/null ; do sleep 5 ; don=
e

But that's quite ugly, as:
- it's an active polling, and it is time consuming (even if slightly)
- it may even be unreliable, as I guess one cannot ensure that /proc/md=
stat
  will print the "recovery" string during the (very short, but well...)
  transition between two partitions to recover

I think that a passive wait would be much better instead.
And ideally, we should have a simple and efficient way to let a program
know if a device is in a clean state (or being recovered), and another
that would wait until the device is clean (recovery finished).

So, the while loop could be replaced by something like
 mdadm --recovery-wait    (for example)
which would exit only when all pending recoveries have finished, and
let the script continue.
That would be much practical, reliable, and cleaner than a loop, don't =
you
think?

How this could be achieved is another question... probably the best
would be that userspace can select on a file descriptor, or something
like that (netlink device?)
What do you think?

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
