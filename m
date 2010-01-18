From: sylarrrrrrr@aim.com
Subject: Re: How to load preexisting ntfs partitions that are on an Intel Matrix
 Raid 1 or 5 ?
Date: Mon, 18 Jan 2010 16:36:39 -0500
Message-ID: <8CC669D740FEC18-9F4-2D9CA@webmail-d051.sysops.aol.com>
References: <8CC636345AA2F7E-295C-545@webmail-d049.sysops.aol.com> <8CC636C98CCAF21-295C-17C7@webmail-d049.sysops.aol.com> <20100116090848.GA21855@maude.comedia.it> <8CC64CAEA9C15A3-938C-10EBD@webmail-m048.sysops.aol.com> <20100118075315.GB28405@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100118075315.GB28405@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, I will try it.

it being "issuing "dmraid -an" should suffice then just run "mdadm=20
-As"."

However before I will, I would like to know if this is safe?
Is there a chance that I will lose all my data simply from this and=20
mounting, I ask since it is a new feature.


-----Original Message-----
=46rom: Luca Berra <bluca@comedia.it>
To: linux-raid@vger.kernel.org
Sent: Mon, Jan 18, 2010 9:53 am
Subject: Re: How to load preexisting ntfs partitions that are on an=20
Intel Matrix Raid 1 or 5 ?


On Sat, Jan 16, 2010 at 08:57:03AM -0500, sylarrrrrrr@aim.com wrote:=C2=
=A0
> OK So this is the mdadm mailing list, and the /dev/mapper is=20
irrelevant > here, right? So ...=C2=A0
>=C2=A0
> How do I load my existing raid arrays with mdadm?=C2=A0
=C2=A0
first make sure they have not been claimed by dmraid.=C2=A0
issuing "dmraid -an" should suffice=C2=A0
then just run "mdadm -As".=C2=A0
looking at /proc/mdstat you should see a container device (or array=C2=A0
using windows driver terminology) and the actual=C2=A0
raid volume.=C2=A0
under /dev/md you should also find meaningful device names and device=C2=
=A0
file for the partitions contained in the volume.=C2=A0
=C2=A0
<snip>=C2=A0
=C2=A0
> PS. I am not next to that machine right now, but I have 3 raid=20
devices on > it and in the /dev/mapper there were about 6 or 8 devices=20
some of which had > similar names and consecutive numbers e.g.=20
xxxxxxxxxxxxx_System1 > xxxxxxxxxxxxx_System2 xxxxxxxxxxxxx_System3=20
while my partition on one of > the raid devices was called System and=20
was raid 1 of two disks.=C2=A0
=C2=A0
please quote either above or below, it is a pain to read if you quote=20
in=C2=A0
the middle.=C2=A0
That said, you use the term 'device' above with two differemt meanings,=
=C2=A0
and i am not quite sure of what you intend.=C2=A0
please elaborate on "I have 3 raid devices"=C2=A0
- 3 hard disks in the container (array)=C2=A0
- a container with three volumes=C2=A0
=C2=A0
then you probably mix partition and volume=C2=A0
xxxxxxxxxxxxx_System1 is the first partition on volume System of Array=C2=
=A0
xxxxxxxxxxxxx (unfortunately arrays dont have meaningful names)=C2=A0
xxxxxxxxxxxxx_System2 is the second partition ....=C2=A0
and so on=C2=A0
=C2=A0
-- Luca Berra -- bluca@comedia.it=C2=A0
=C2=A0       Communication Media & Services S.r.l.=C2=A0
=C2=A0/"\=C2=A0
=C2=A0\ /     ASCII RIBBON CAMPAIGN=C2=A0
=C2=A0 X        AGAINST HTML MAIL=C2=A0
=C2=A0/ \=C2=A0
--=C2=A0
To unsubscribe from this list: send the line "unsubscribe linux-raid"=20
in=C2=A0
the body of a message to majordomo@vger.kernel.org=C2=A0
More majordomo info at  http://vger.kernel.org/majordomo-info.html=C2=A0

 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
