From: Zoltan Szecsei <zoltans@geograph.co.za>
Subject: Re: mdadm raid6->LVM->ext4 setup
Date: Wed, 17 Nov 2010 09:49:27 +0200
Message-ID: <4CE38907.8040709@geograph.co.za>
References: <4CE2C8AC.7010103@geograph.co.za> <20101116221722.GC8943@maude.comedia.it> <4CE31641.50909@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE31641.50909@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2010-11-17 01:39, Michal Soltys wrote:
> On 10-11-16 23:17, Luca Berra wrote:
>> On Tue, Nov 16, 2010 at 08:08:44PM +0200, Zoltan Szecsei wrote:
>>>
>>> *** Commands used:
>>> mdadm --create /dev/md0 --metadata=3D1.2 --auto=3Dmd --assume-clean
>>> --bitmap=3Dinternal --bitmap-chunk=3D131072 --chunk=3D512 --level=3D=
6
>>> --raid-devices=3D8 /dev/sd[abcdefgh]
>>> mdadm --detail --scan >> /etc/mdadm.conf
>>> mdadm --assemble /dev/md0
>> as i said this is not useful
Accepted, but I also understood "not harmfull". I tried it out of=20
curiosity, it took a nano-second to complete, so didn't try to "undo it=
".
>>> pvcreate --metadatasize 512 /dev/md0
>> you should use --dataalignment, not --metadatasize, also you should
I checked out man pvcreate & lvm.conf had all the stuff below in it, so=
=20
I assumed it would sort itself out.
md_component_detection =3D 1
md_chunk_alignment =3D 1
data_alignment_detection =3D 1
data_alignment_offset_detection =3D 1

>
> Also with reference to metadatasize - keep in mind the value is=20
> rounded up to the /next/ 64k boundary (or it was a while ago, perhaps=
=20
> it's changed now). So in your case, 512 would really result with 576.
>
> With reference to --dataalignment - there's also --dataalignoffset=20
> option (although not really important in your setup).
>
> You might consider adjusting=20
> /sys/block/<yourmddevice>/md/stripe_cache_size to higher values when=20
> you have everything set. It tends to give quite a performance boost.

I had trouble getting my head around all the calculations, mainly=20
because I do not know if my sector size of 512 is falsely reported or=20
not (so I just accepted it as 512).

I am loading the array as we speak, with 200MB to 400MB tiff files. In=20
the past 11 hours approx 995GB was loaded, so that calculates to a writ=
e=20
speed of 25MB/s

I have no problem stopping & deleting this if you feel that this=20
represents problems in my setup, but then please can someone do the=20
alignment calculations & command syntax for me.
Regards to all,
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
Version: 10.0.1153 / Virus Database: 424/3261 - Release Date: 11/16/10

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
