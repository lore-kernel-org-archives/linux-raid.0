From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: 16 HDDs too much for RAID6?
Date: Fri, 7 Mar 2008 11:45:55 +0100
Message-ID: <20080307114555.6ce17158.taeuber@bbaw.de>
References: <20080306100128.8daad6bd.taeuber@bbaw.de>
	<20080306094559.GA29734@skl-net.de>
	<20080306115559.63ac361d.taeuber@bbaw.de>
	<20080306161621.GD32242@skl-net.de>
	<20080307084146.GA9653@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080307084146.GA9653@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

Luca Berra <bluca@comedia.it> schrieb:
> On Thu, Mar 06, 2008 at 05:16:21PM +0100, Andre Noll wrote:
> >On 11:55, Lars T=C3=A4uber wrote:
> >> monosan:~ # cat /etc/mdadm.conf=20
> >> DEVICE partitions
> >> ARRAY /dev/md2 level=3Draid1 UUID=3Dd9d31de2:e6dbd3c3:37c7ea09:882=
a64e5
> >> ARRAY /dev/md3 level=3Draid1 UUID=3Da8687183:a79e514c:ca492c4b:ffd=
4384f
> >> ARRAY /dev/md4 level=3Draid6 num-devices=3D16 UUID=3D8d596319:4d21=
dba3:3871bccf:5b90a66d
> >
> >Does it help to list only the 16 devices that are used for the array=
,
> >i.e. something like
> >
> >	DEVICE /dev/sd[a-p]

because the devices sd[c-z] and sda[a-h] are used by multipathd they ar=
e accessible in read only mode only. For writing /dev/dm-* devices are =
available.

> i hope kernel will pevent you from doing something this stupid, but i=
 am
> not that sure.
> if you wanna check if the problem is device selection a more appropri=
ate
> line would be
> DEVICE /dev/mapper/mpath*
> or
> DEVICE /dev/dm-[0-9] /dev/dm-1[0-5]

Correct.
My mdadm.conf has now this line for safety:
DEVICE /dev/sd[ab][0-9] /dev/dm-*

But this doesn't really changed anything.

> >I think this is what is confusing mdadm. Your "DEVICE partitions"
> >line instructs mdadm to consider all devices in /proc/partitions,
> >so it finds both sdy and sdi.
> in this case i believe the error message would be different
>=20
> >> Is there a way to get more verbose infos or debug this anyhow?
>=20
> you could try with the --verbose option and post the results here.
>=20
> also could you check if the minor number of /dev/dm-* are really uniq=
ue?
>=20
> in case this yelds no result we will have to add some more printf in
> Assemble.c.

I zeroed out all physical devices completely:
# for DEV in /dev/sd[c-r]; do dd if=3D/dev/zero of=3D$DEV; done

Now the problem is gone. I don't know what really caused the problem.
Many thanks for your suggestions.

Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
