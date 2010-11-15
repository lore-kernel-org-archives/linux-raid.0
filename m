From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Mon, 15 Nov 2010 13:06:30 +0200
Message-ID: <4CE11436.1010208@geograph.co.za>
References: <4CE00206.4000301@geograph.co.za> <20101114195036.GA23982@maude.comedia.it> <4CE0D8B0.4050603@geograph.co.za> <20101115074125.GB5490@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115074125.GB5490@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-15 09:41, Luca Berra wrote:
> btw to check sector size on a disk, on a fairly recent kernel you can
> check the files under /sys/block/*/queue,
> hw_sector_size
512
> minimum_io_size
512
> optimal_io_size
0
>
> except for disks that lie about their sector size, but this is a
> different story.
>> root@gs0:/home/geograph# mdadm -V
>> mdadm - v2.6.7.1 - 15th October 2008
> this mdadm release is a tad old (about two years), it will work, but
> some things may be different than current 3.1.x
>
just downloaded the tarball for 3.1.4 and will have a crack at compilin=
g it.


Thanks !

Z


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
Version: 10.0.1153 / Virus Database: 424/3257 - Release Date: 11/14/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
