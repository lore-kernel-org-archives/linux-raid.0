From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: RAID 5 : recovery after failure
Date: Wed, 9 Oct 2013 08:22:32 +0200
Message-ID: <CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
	<20131008210603.GA22876@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131008210603.GA22876@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> As far as the array goes, it looks like you _should_ be able to force
> assembly with sdc1, sde1 & sdf1.

Impossible :(
Always this superblock error.

mdadm: looking for devices for /dev/md127
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: /dev/sdf1 has no superblock - assembly aborted

I don't know where this "busy" message comes from : I have no mount
nor RAID service started.

> Make sure you set the ERC/timeouts before attempting to re-add either=
 of
> the other disks though.

Sure, I will :)

gUI

--=20
Pour la sant=E9 de votre ordinateur, pr=E9f=E9rez les logiciels libres.
Lire son mail : http://www.mozilla-europe.org/fr/products/thunderbird/
Browser le web : http://www.mozilla-europe.org/fr/products/firefox/
Suite bureautique : http://www.libreoffice.org/download/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
