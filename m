From: Drew <drew.kay@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 11:41:39 -0700
Message-ID: <c268e4660910051141r125e943csa91dad2ede6d41f5@mail.gmail.com>
References: <c268e4660910050849mc4bba01ifbb1a57caf59c41a@mail.gmail.com>
	<20091005181306574.NWBS26368@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091005181306574.NWBS26368@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 =C2=A0 =C2=A0 =C2=A0 =C2=A0True, but it is simpler than that. =C2=A0Pa=
rtitions are not needed in
> general unless one needs to create a separate task space on a single =
drive
> volume. =C2=A0If one has no swap space, then it is entirely possible =
to run a
> Linux system with no partitions at all. =C2=A0The file system can be =
created on a
> raw disk, and as long as the MBR is good and the boot loader can read=
 the
> file system, you're good. =C2=A0Note I don't genrally recommend runni=
ng without a
> swap space, and going to extra trouble just to prevent partitioning i=
s not
> very productive, but there is no reason to partition a drive if it is=
 not
> necessary, whether the "drive" is a single physical disk or an array.

I did not know that. I always assumed that for physical disks you
needed a partition of some sort so the filesystem doesn't stomp all
over the boot sector (where used).That said I think I'll stick to
partitioning my boot drive. Feels safer somehow.

>> The filesystem still needs a partition/volume but that can created
>> either by partitioning /dev/mdX *or* creating a logical volume in LV=
M.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0It doesn't need a partition, just a block =
device. =C2=A0That device can
> be a partition on a disk, a whole disk, or an array.

I forgot you can do that with mdX. It's been a while since I've made
filesystems (other then boot drives) without LVM.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
