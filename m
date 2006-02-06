From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs
 running
Date: Mon, 6 Feb 2006 11:09:25 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0602061105300.14030@shaka.acc.umu.se>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
 <43E68D62.4080704@cogweb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E68D62.4080704@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Feb 2006, David Liontooth wrote:

> In designing an archival system, we're trying to find data on when it
> pays to power or spin the drives down versus keeping them running.
>
> Is there a difference between spinning up the drives from sleep and f=
rom
> a reboot? Leaving out the cost imposed on the (separate) operating
> system drive.

Hitachi claims "5 years (Surface temperature of HDA is 45=B0C or less) =
Life=20
of the drive does not change in the case that the drive is used=20
intermittently." for their ultrastar 10K300 drives. I suspect that the=20
best estimates you're going to get is from the manufacturers, if you ca=
n=20
find the right documents (OEM specifications, not marketing blurbs).

=46or their deskstar (sata/pata) drives I didn't find life time estimat=
es=20
beyond 50000 start-stop-cycles.

/Mattias Wadenstein
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
