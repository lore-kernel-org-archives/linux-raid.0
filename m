From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 08:58:12 +0200
Message-ID: <4CE0DA04.1010308@geograph.co.za>
References: <4CE00206.4000301@geograph.co.za> <20101115091326.42b38b84@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115091326.42b38b84@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-15 00:13, Neil Brown wrote:
>
> Depending on which version of mdadm you are using, the default chunk =
size
> will be 64K or 512K.  I would recommend using 512K even if you have a=
n older
> mdadm.  64K appears to be too small for modern hardware, particularly=
 if you
> are storing large files.
>   =20
root@gs0:/home/geograph# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008
root@gs0:/home/geograph#

This was what apt-get install got for me, from Ubuntu 10.04 64bit Deskt=
op.
Should I download & compile a newer one?
(Where from? - haven't found the mdadm developer page yet))


> For raid6 with the current implementation it is safe to use "--assume=
-clean"
>   =20
Is my above version "current" enough?
> to avoid the long recovery time.  It is certainly safe to use that if=
 you
> want to build a test array, do some performance measurement, and then=
 scrap
> it and try again.  If some time later you want to be sure that the ar=
ray is
> entirely in sync you can
>    echo repair>  /sys/block/md0/md/sync_action
> and wait a while.
>
> I agree with what Mikael and Luca suggested - particularly the sugges=
ted for
> "--bitmap internal".  You really want that.
>
>
> N
>   =20

Regards & thanks,
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
Version: 10.0.1153 / Virus Database: 424/3256 - Release Date: 11/14/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
