From: Jose Luis Domingo Lopez <linux-raid@24x7linux.com>
Subject: Re: RAID1 over RAID0 misbehavior
Date: Wed, 7 Jan 2004 21:09:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040107200951.GB5143@localhost>
References: <yw1xbrpgwq4f.fsf@ford.guide>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yw1xbrpgwq4f.fsf@ford.guide>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday, 07 January 2004, at 01:37:20 +0100,
M=E5ns Rullg=E5rd wrote:

> I recently created a RAID1 mirror from two identical RAID0 arrays
> under Linux 2.6.0.  I was surprised when /proc/mdstat reported a
> resync speed of 1 MB/s, even though the system was otherwise idle.  I
>
Anyways, it seems wiser to make two RAID1 arrays and then a RAID0 from
them two. Apart from (maybe) preventing the problem you are
experiencing, this should give you better results in the case of a driv=
e
failure, when it happens.

Think for a moment about the event of a single hard drive failure: with
two RAID1 arrays, one of then will go to degraded mode, but as far as I
know the upper RAID0 will not notice a thing, so will continue working
as usual, maybe with a little performance decrease.

On the other hand, if you have two RAID0 arrays and one of the hard
drives fail, the RAID0 where it happens will fail, the upper RAID1 will
run degraded, and when a new disk replaces the failed one you will have
to start the failed RADI0 again, and let the upper RAID1 reconstruct
itself. I think this situation is worse than the one depicted before.

Am I missing something ?

Greetings.

--=20
Jose Luis Domingo Lopez
Linux Registered User #189436     Debian Linux Sid (Linux 2.6.1-rc2)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
