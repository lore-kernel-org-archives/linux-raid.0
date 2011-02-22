From: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 17:32:17 -0700
Message-ID: <20110222003217.GA29101@bounceswoosh.org>
References: <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
 <iiud2r$qci$1@dough.gmane.org>
 <4D62ACFE.4020401@cfl.rr.com>
 <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
 <AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
 <AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
 <AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
 <4D62CF5F.6080007@cfl.rr.com>
 <AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
 <AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 21 at 19:52, Roberto Spadim wrote:
>i don=B4t think so, since it=B4s ATA command, any ATA compatible can u=
se
>it, it could be used for HD with badblocks and dynamic reallocation
>without problems, the harddisk don=B4t need a dedicated space for
>badblock. for md software we must know if devices support or not TRIM.

It's been 15 or more years since hard drives exposed their bad blocks
to the host, I don't think it'd be a good idea to revisit that
decision.

--=20
Eric D. Mudama
edmudama@bounceswoosh.org

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
