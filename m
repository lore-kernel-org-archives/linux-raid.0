From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: md: bug in file raid5.c, line 540 (kernel 2.4.20)
Date: Mon, 14 Apr 2003 00:37:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030413223727.GA4632@marowsky-bree.de>
References: <Pine.LNX.4.53.0304140015310.24622@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0304140015310.24622@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-04-14T00:21:27,
   Stephan van Hienen <raid@a2000.nu> said:

> trying to do a raidsetfaulty on my hotspare disk (i was trying to see=
 if i
> would get any email from mdadm --monitor)
>=20
> i can reproduce this bug

Yes, it doesn't seem like this is a not-well-exercised code path. I've =
fixed
that for multipath in our tree, but as it depends on some patches /
enhancements to multipathing I can't get Neil, mingo or anyone else to =
comment
on I've not bothered to post the patch.

The current advise seems to be to not do that...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
