From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: mdadm raid6->LVM->ext4 setup
Date: Tue, 16 Nov 2010 20:23:41 +0200
Message-ID: <4CE2CC2D.6040109@geograph.co.za>
References: <4CE2C8AC.7010103@geograph.co.za> <20101116231657.011c6886@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101116231657.011c6886@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-16 20:16, Roman Mamedov wrote:
> On Tue, 16 Nov 2010 20:08:44 +0200
> Zoltan Szecsei<zoltans@geograph.co.za>  wrote:
>
>   =20
>> 8 * 5900RPM Seagte 2TB drives on SiI3132 PCIx x1 card.
>>     =20
> Excuse me, but how is that? This is a 2-port controller, so do you us=
e port
> multipliers, or 4 cards? (The latter would work an order of magnitude=
 faster.)
>
>   =20

The chassis has 2 * 4 port multipliers

http://www.chyangfun.com/pro01_2_3.asp

Regards,
Zoltan



--=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Zoltan Szecsei PrGISc [PGP0031]
Geograph (Pty) Ltd.
P.O. Box 7, Muizenberg 7950, South Africa.

65 Main Road, Muizenberg 7945
Western Cape, South Africa.

34=B0 6'16.35"S 18=B028'5.62"E

Tel: +27-21-7884897  Mobile: +27-83-6004028
=46ax: +27-86-6115323     www.geograph.co.za
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 10.0.1153 / Virus Database: 424/3260 - Release Date: 11/16/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
