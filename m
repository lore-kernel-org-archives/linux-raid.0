From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Mon, 13 Apr 2015 06:57:48 -0400
Message-ID: <552BA12C.3010506@turmel.org>
References: <D150B36B.8EE37%marchesseau@gmail.com> <552B0B58.8050102@turmel.org> <D15148A7.3B83B%marchesseau@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D15148A7.3B83B%marchesseau@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas MARCHESSEAU <marchesseau@gmail.com>, linux-raid@vger.kernel.org
Cc: Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

Good morning Thomas,

{ Convention on kernel.org is to reply-to-all, trim quotes, and place
your response inline or at the bottom. }

On 04/13/2015 04:55 AM, Thomas MARCHESSEAU wrote:
> Hi all,=20
>=20
> Thanks a lot for your time. I appreciate .

You're welcome.

> Immediate Feedback  (with jet lag :) -
>=20
> Roger, =20
> 	I=E2=80=99ve already forced the =E2=80=94- assemble, just forget to =
write it  , no more
> 	mdadm  --assemble --force  /dev/md127 /dev/sdb /dev/sdc /dev/sdd /de=
v/sde
>  /dev/sdf /dev/sdg /dev/sdh
> 	mdadm: /dev/md127 assembled from 5 drives - not enough to start the =
array.

Hmmm.  Based on the below, this should have worked.  Please report your
mdadm version.  Your kernel appears to be 3.16.0.  There have been some
assembly bugs fixed in the past year.  You will certainly want to try
with a recent livecd before giving up on --assemble --force.

> 	I=E2=80=99ll move to raid6 , that was my 1st choice, but i didn=E2=80=
=99t build it

Wait!  One thing at a time.  First we must recover your array and help
you get a better backup.  Then you may add another drive to make a raid=
6.

> Phil,
> 	Md0 ..  I got the point,  I will use it again to avoid mistakes

This is what mdadm.conf is for.  And must be replicated into your
initramfs to be effective for most distributions.

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
> OUTPUT of : or x in /dev/sd[b-h] ; do mdadm -E $x ; smartctl -iA -l s=
cterc
> $x ; done > report.txt

Very good.  Some of your devices have SMART disabled.  You should enabl=
e
those, and re-do the smart report for them.

> /dev/sdb:
>    Device Role : Active device 5
> Serial Number:    WD-WCC1P1091161

> /dev/sdc:
>    Device Role : Active device 0
> Serial Number:    WD-WCC1P1097832

> /dev/sdd:
>    Device Role : Active device 1
> Serial Number:    WD-WCC1P1097658

> /dev/sde:
>    Device Role : Active device 2
> Serial Number:    WD-WCC1P1111248

> /dev/sdf:
>    Device Role : Active device 3
> Serial Number:    WD-WCC1P1107956

> /dev/sdg:
>    Device Role : Active device 4
> Serial Number:    WD-WCC1P1164520

> /dev/sdh:
>    Device Role : Active device 6
> Serial Number:    WD-WCC1P1154279

The above is critical data for later if assembly never works.

Meanwhile, please obtain your dmesg and paste it here.  I suggest
turning off line wrap when you paste into your email.

Next, boot with a recent liveCD that has mdadm utilities (I recommend
systemrescuecd from sysrescuecd.org.) and use its kernel and tools to
try "mdadm -Afv /dev/md0 /dev/sd[b-h]"

You may have to --stop a partial assembly, as rescue CDs often attempt
to assemble arrays found.  And adjust the device letters if it boots
with your system disk as other than sda.

Show the mdadm output if it fails.  If it works, back up your critical
files immediately.  You should then do a clean shutdown, and it should
let you boot back into your original system.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
