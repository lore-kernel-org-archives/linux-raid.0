From: Franck Routier <franck.routier@axege.com>
Subject: Re: Understanding bonnie++ results
Date: Sat, 01 Mar 2008 21:25:45 +0100
Message-ID: <1204403145.13527.8.camel@franck-gusty>
References: <1204191989.16924.10.camel@franck-gusty>
	 <47C9B6C3.40505@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47C9B6C3.40505@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Le samedi 01 mars 2008 =C3=A0 15:04 -0500, Bill Davidsen a =C3=A9crit :
> Do you have a base raw read speed for a single drive? That helps=20

Disk speed measured by hdparm -t shows :
Timing buffered disk reads:  270 MB in  3.02 seconds =3D  89.52 MB/sec

> Adaptec hw raid10 really raid1+0 or the distributed raid10 done by Li=
nux=20
> sw raid?

I don't know, but RAID10 is an option on it's own in the bios (I don't
have to build raid 1 then raid 0)

=46ranck


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
