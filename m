From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: Sync rates?
Date: Thu, 06 May 2004 21:32:23 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xsmede4hk.fsf@kth.se>
References: <00a401c4339e$7f86b340$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

<me@heyjay.com> writes:

> Hi,
>
> I added a 120GB drive to a degraded raid 1 drive (well it's really 5
> partitions all raid 1).  I started last night (maybe 8pm) at this rat=
e it
> will be done syncing in just under 24 hours.  Is this sync rate expec=
ted?  I
> would have thought 120GB wouldn't have taken that long, I'm running 7=
200RPM
> IDE drives on separate controllers, with an Athlon 3200.

My raid1 over two 240GB raid0 arrays sync in about 3 hours.  Maybe you
are syncing all 5 partitions at the same time.  That would be likely
to cause a slowdown since the disk would be seeking quite a bit.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
