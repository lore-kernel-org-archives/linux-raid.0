From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 1 Apr 2004 11:07:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401090731.GI6923@chihiro.cern.ch>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B27E4.1000106@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <406B27E4.1000106@sauce.co.nz>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Richard Scobie (richard@sauce.co.nz) [20040401 08:19]:

> 3ware hardware RAID 10: Reads - 92.8MB/s    Writes - 88.9MB/s
> Software RAID 10:  Reads - 53.7MB/s   Writes - 94.9 MB/s

> If anyone is running similar hardware and is able to get better
> software RAID performance, I would be very interested to hear
> the parameters.

I've tested some configurations with 128 GiB streams (iozone) on a
dual Xeon 2.4GHz 2G RAM machine (running XFS).

3ware HW-RAID1, Linux SW-RAID0:	read 263 MiB/s, write 157 MiB/s
3ware HW-RAID5, Linux SW-RAID0:	read 243 MiB/s, write 135 MiB/s
Linux SW-RAID5:			read 225 MiB/s, write 135 MiB/s
3ware HW-RAID10:		read 119 MiB/s, write  91 MiB/s

Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern.c=
h
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
