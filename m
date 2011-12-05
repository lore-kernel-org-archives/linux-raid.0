From: Doug Dumitru <doug@easyco.com>
Subject: Re: Is this stupid?
Date: Sun, 4 Dec 2011 22:18:00 -0800
Message-ID: <CAFx4rwRzUM3kh5vTmqoiH84s7kGD54cjqGAcrdhRxYEm03NVsw@mail.gmail.com>
References: <D4.5D.10364.904FBDE4@cdptpa-omtalb.mail.rr.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D4.5D.10364.904FBDE4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mr. Rhorer,

Don't work too hard over-thinking this in terms of wearing the stick
out.  Current USB sticks are built with dirt cheap, often three bits
per cell flash with lousy endurance and minimal wear leveling.  Even
so, if you have an 8GB stick that writes at 5 MB/sec and 600
endurance, it still takes 11 days of 100% busy writes to kill it.

The real issue with booting from a USB stick (and the same rules apply
to CF cards), is that some operations like syslogd sync writes can
take forever and then some.

One other trick is to either use a more "flash friendly" file system,
or at least turn off atime tracking.

Doug Dumitru
EasyCo LLC

On Sun, Dec 4, 2011 at 2:28 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
> I have a system - one that is not expandable - that has relatively li=
mited
> RAM, comparatively speaking, and must boot from a usb stick. =A0The s=
ystem
> hosts a RAID array, but one cannot assume the RAID array is available=
 when
> the system boots. =A0IOW, I want to be able to take down the RAID arr=
ay for
> maintenance, possibly booting the system with no array created, at al=
l.
>
> On the other hand, USB sticks have a limited number of writes availab=
le
> before they fail, so I don't want the system to be thrashing the flas=
h drive
> any more than necessary. =A0At this time, =A0I have /var/run, /var/lo=
g,
> /var/lock, and /tmp mounted as tmpfs file systems. =A0What I propose =
is to run
> an init script that checks to see if the array is mounted, and if so =
appends
> files in the aforementioned directories to existing directories on th=
e array
> and then remounts and binds the directories on the array. =A0The stop=
 call in
> the script will reverse the process so the system can shutdown or so =
I can
> take the array offline after booting for maintenance. =A0Is this unwi=
se? =A0Am I
> missing something crucial that might cause the system to blow up?



--=20
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
