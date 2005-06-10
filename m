From: Brad Dameron <brad@seatab.com>
Subject: Re: RAID 5 of RAID 5's?
Date: Fri, 10 Jun 2005 08:42:39 -0700
Message-ID: <1118418159.8460.1.camel@serpent>
References: <1118187572.15459.96.camel@seki.nac.uci.edu>
	 <42A93D30.6080900@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A93D30.6080900@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-06-10 at 00:11, Laurent CARON wrote:
> Dan Stromberg a =C3=A9crit :
>=20
> >Has anyone constructed a RAID 5 of RAID 5's using mdadm on a linux
> >system?
> >
> >Was it reliable?
> >
> >How large was it?
> >
> >Thanks!
> >
> > =20
> >
> Seems to be a large waste of space....
> -

Ya that does. I have done a RAID0 of 2 RAID5's. Or a RAID50. Work's
great. I think a RAID5 of RAID5's is going to have some seriously slow
write performance.=20

Brad Dameron
SeaTab Software
www.seatab.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
