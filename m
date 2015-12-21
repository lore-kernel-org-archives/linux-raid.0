From: NeilBrown <nfbrown@novell.com>
Subject: Re: Reshape stalls and fails when SELinux is enabled
Date: Mon, 21 Dec 2015 12:50:29 +1100
Message-ID: <877fk8604a.fsf@notabene.neil.brown.name>
References: <CAMQd7mbdqsw5BiRSKbgBqwNFrz4V8T-A3hOftWReRk1XgXc=+Q@mail.gmail.com> <CAMQd7mYscUDroop=4eLz4UwTEiibbF0OqDN1b28yiqJyfW7gGw@mail.gmail.com> <CACsGCyQX4DKfT-6CYd7pa8P-Rq12HhP2tA79F27rw1PbNHe_QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyQX4DKfT-6CYd7pa8P-Rq12HhP2tA79F27rw1PbNHe_QQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>, Enrico Tagliavini <enrico.tagliavini@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 11 2015, Edward Kuns wrote:

> I ran into this as well.  I unwisely worked around it by placing the
> backup file on /tmp.  I don't recommend that choice!  I didn't see
> your AVC on your EMail, but I recommend you reach out to the SELinux
> folks for labeling help.  I've reach out to them in the past and have
> found them very helpful (as are the folks here).  Getting the labeling
> corrected will not only help you but everyone else in the long term.
>
> I agree that it would be good for mdadm to handle this kind of failure
> in a more productive fashion as well.  But I'm only a lurker here.  I
> don't have enough knowledge to suggest what would be better.  One
> thing that really helped me debug this was commenting out the lines
>
> #StandardOutput=null
> #StandardError=null
>
> in the systemd file /lib/systemd/system/mdadm-grow-continue@.service
> -- note you have to run systemctl daemon-reload after changing the
> file for the change to be noticed.
>
> Once I did that, the system logs had much more useful information.
> I'm not sure where that file is sourced, whether it's from the
> linux-raid people or from the distributions or somewhere in between.
> Does anyone here know if there's a reason why standard out and
> standard error are sent to /dev/null for this service?

That mdadm-grow-continue@.service file is part of mdadm (in the systemd
directory).
As for why stdout/err is set to 'null', you could try finding out who
did that and ask them ....

http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=5e76dce1acd906e8fc8af04973c3a129cdc77fd6

but I'm pretty sure that he has no idea.

You could try sending me a patch which changes those lines and gives some
sort of explanation why it is a good change to make.
There is a very good chance that I would apply that patch.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd1rlAAoJEDnsnt1WYoG5NlwP/ixc0fGflPflWCrfjDjHKl86
Pqy6V6gGBi+H/9AT6wZvoeAwG1lohNAvGevPVEScYEgPQ03DcJgqGPqAuosUhVgQ
NCdEjgI8J44TuOImQcOhpXXagegWmn0p3SdbNAsgjME06eOsTIp+Yz33tDLFKHUr
TKp4AzbvQxgYNLaBo72OcMUpCM8yHDAThtlaGRfdYDJs4x/N0tFo6OFg8REfEueJ
1UXWbM+J+w1Wk6TsTP5X0sQOlNjXjFaEaqcCrwHhPIN8nk8FZB/Y08mP+TPLlzuL
YEONBQyRKqvQADSPEhnC2WoqL7JtlimY37bVE26BH+MnwH5jEkcXOXmPwU1K/LFA
yjlIvuI+V7bJ2Y77dT3y8gInSJnWDIPw+yxgXMuc87/qpMi9RkkytidfGdyW8ED9
YZNcT4W61d5OUZljr8jFDKMm79TgGDlEgOGp3h1IzA2roX0AxwAP53cmbk6kJjaQ
a2OGftl3twhQJsq1dh+n2bTYckXEGmSbh30aooB5q8zO7FfLJzT31miJN4TCpNgP
qSweAtOO6Ll75luPvnb/YzjiPjVto/I/MlnjYeVBk3PQ+f68Tp+7xx6YN0zf2v8n
ilmSzPPAdVXmK+hVOozBNIqmtv348vDxZJRtdpPngvg5ME1QnFMO1Sh7XpEqoBQC
7JPCYyBlUh+/BMACLDLO
=fqg/
-----END PGP SIGNATURE-----
--=-=-=--
