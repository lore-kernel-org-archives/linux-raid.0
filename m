From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 10:54:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031027095434.GB13640@marowsky-bree.de>
References: <1067179519.1222.107.camel@cala> <200310261716.17030.maarten@vbvb.nl> <200310270927.32751.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200310270927.32751.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>, maarten van den Berg <maarten@vbvb.nl>, Mario Giammarco <mgiammarco@virgilio.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-27T09:27:32,
   Hermann Himmelbauer <dusty@strike.wu-wien.ac.at> said:

> When reading a file from the RAID1, you could e.g. read the first blo=
ck from=20
> the first disk, the second from the second disk, the third from the f=
irst=20
> disk and so on.
>=20
> This would *theoretically* double the read speed - like with RAID0.

=46or pure reads, that may be true. But for writes, the disks have to
resynchronize their heads and then you would get a penalty there.

It all depends ;-)

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
