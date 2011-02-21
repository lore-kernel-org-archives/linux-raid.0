From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 15:45:24 -0500
Message-ID: <4D62CEE4.2080207@cfl.rr.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>	<4D517F4F.4060003@gmail.com>	<4D5245DF.4020401@hardwarefreak.com>	<iiu4rc$9ju$1@dough.gmane.org>	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>	<iiud2r$qci$1@dough.gmane.org>	<4D62ACFE.4020401@cfl.rr.com>	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>	<AANLkTinPrCw+wTns6Jb8ZNwwMPoKuV9sr5LXqjPtJyUn@mail.gmail.com> <AANLkTik7=t_QsMyk9ogmg6ygZzEL=ErTP24OWz8Zsb+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik7=t_QsMyk9ogmg6ygZzEL=ErTP24OWz8Zsb+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/21/2011 2:39 PM, Mathias Bur=C3=A9n wrote:
> Plus support is needed from the kernel (done) filesystem (ext4 has
> it). The filesystem seese the MD device, not the actual SSDs behind
> it, so it would probably be quite complicated to implement passthroug=
h
> of the trim command in this case.

It has been mentioned at least twice now how to implement it.  The
device-mapper driver already has implemented TRIM passthrough for its
linear, stripe, and mirror targets.  The trick is handling it with raid=
[56].
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
