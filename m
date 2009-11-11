From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Wed, 11 Nov 2009 00:04:31 -0700
Message-ID: <200911110004.31238.tfjellstrom@shaw.ca>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com> <4AF9A89B.80400@sauce.co.nz>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9A89B.80400@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue November 10 2009, Richard Scobie wrote:
> Kristleifur Da=F0ason wrote:
> > Can anyone confirm/deny that the PCIe JBOD controllers from LSI wor=
k
> > on Linux out of the box? Or give other recommendations for 8 port
> > controllers in the $150-$200 range? (Or thereabouts. It'd be great =
to
> > know about any known-good 4-port controllers for even up to $250.)
>=20
> You should have no problem at all. I have used a number of the:
>=20
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_h=
bas/
> combo/sas3442e-r/index.html
>=20
> controllers.
>=20
> The only thing to watch out for, as has been discussed in the last fe=
w
> days, is that use of smartmontools to monitor disk health on these 10=
68
> based cards, wll cause drives to be offlined, when used with recent
>  kernels.
>=20
> Regards,

Thats the problem he was trying to get away from. the MV8 controller li=
kes=20
to offline disks when a few smart commands arrive. at least with the ma=
in=20
kernel drivers. But then the main kernel mvsas drivers decide to give u=
p if=20
you even attempt to start a raid array on them. The controller locks up=
 and=20
you have to reboot. Most of the time a reboot even fails when it tries =
to=20
sync the block devices, so a hard reset is in order.

But as I mentioned in a previous message, the driver snapshot I got fro=
m a=20
nice fellow seems to work fine now. I hope it gets into the kernel some=
time=20
soon.

> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
