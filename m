From: Lapohos Tibor <tibor.lapohos@rogers.com>
Subject: Embedding area too small... (GRUB2 on software RAID1)
Date: Tue, 5 Jan 2010 10:30:42 -0800 (PST)
Message-ID: <326592.34440.qm@web88208.mail.re2.yahoo.com>
References: <20100105112324.GE5847@riva.ucam.org>
Reply-To: The development of GNU GRUB <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0145616295=="
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
In-Reply-To: <20100105112324.GE5847@riva.ucam.org>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/grub-devel>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Sender: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
To: grub-devel@gnu.org, grub-help@gnu.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--===============0145616295==
Content-Type: multipart/alternative; boundary="0-696638304-1262716242=:34440"

--0-696638304-1262716242=:34440
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,
=A0
I successfully set up an Intel Matrix Raid device with=A0a RAID1 and a RAID=
0 volume,=A0each having a couple of partitions, but then I could not instal=
l GRUB2 on the RAID1 volume, which I wanted to use to boot from and mount a=
s root. It turned out that=A0the "IMSM" metadata is not supported in GRUB2 =
(v1.97.1) just yet, so I had to turn away from my original plan.
=A0
To "imitate" the setup I originally wanded, I turned both of my drives into=
 AHCI controlled devices in the BIOS (instead of RAID), and=A0I=A0partition=
ed them to obtain=A0/dev/sda[12] and /dev/sdb[12].
=A0
Then I used /dev/sd[ab]1 to build a RAID1 set, and /dev/sd[ab]2 to create a=
 RAID0 set using mdadm v 3.0.3:
=A0
> mdadm -C /dev/md0 -v -e 0 -l 1 -n 2 /dev/sda1 /dev/sdb1
> mdadm=A0-C /dev/md1 -v -e 0 -l=A00 -n 2 /dev/sda2 /dev/sdb2
=A0
=A0I=A0set the metadata type to 0.90 because I would like to boot from it a=
nd allow the kernel to auto-detect the RAID devices while it's booting,=A0i=
n order to can get away from using an intitrd (I am building my own distrib=
ution based on CLFS x86_64 multilib).
=A0
I used cfdisk to partition both of the /dev/md[01] devices, and I obtained =
/dev/md0p[123] and /dev/md1p[12]. The plan is to use /dev/md0p1 as a RAID1 =
root partition, and have the system boot from /dev/md0. I formatted /dev/md=
0p1 as
=A0
> mk2efs -t ext4 -L OS /dev/md0p1
=A0
To this point, things went smoothly. mdadm -D... and mdadm -E... did report=
 back working devices as intended. Then mounted /dev/md0p1 on a directory c=
alled /root/os, and I did
=A0
> grub-install --root-directory=3D/root/os /dev/md0
or
> grub-install --root-directory=3D/root/os "md0"
=A0
and I got a warning and an=A0error message: "Embedding area is too small fo=
r core.img." and "Embedding is not possible, but this is required when the =
root device is on a RAID array or LVM volume."
=A0
What did I do wrong, and how do I fix it? Thanks ahead,
Tibor
--0-696638304-1262716242=:34440
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<table cellspacing=3D"0" cellpadding=3D"0" border=3D"0" ><tr><td valign=3D"=
top" style=3D"font: inherit;"><P class=3DplainMail>Hello,</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>I successfully set up an Intel Matrix Raid device with=
&nbsp;a RAID1 and a RAID0 volume,&nbsp;each having a couple of partitions, =
but then I could not install GRUB2 on the RAID1 volume, which I wanted to u=
se to boot from and mount as root. It turned out that&nbsp;the "IMSM" metad=
ata is not supported in GRUB2 (v1.97.1) just yet, so I had to turn away fro=
m my original plan.</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>To "imitate" the setup I originally wanded, I turned b=
oth of my drives into AHCI controlled devices in the BIOS (instead of RAID)=
, and&nbsp;I&nbsp;partitioned them to obtain&nbsp;/dev/sda[12] and /dev/sdb=
[12].</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>Then I used /dev/sd[ab]1 to build a RAID1 set, and /de=
v/sd[ab]2 to create a RAID0 set using mdadm v 3.0.3:</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>&gt; mdadm -C /dev/md0 -v -e 0 -l 1 -n 2 /dev/sda1 /de=
v/sdb1</DIV>
<P class=3DplainMail>&gt; mdadm&nbsp;-C /dev/md1 -v -e 0 -l&nbsp;0 -n 2 /de=
v/sda2 /dev/sdb2</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>&nbsp;I&nbsp;set the metadata type to 0.90 because I w=
ould like to boot from it and allow the kernel to auto-detect the RAID devi=
ces while it's booting,&nbsp;in order to can get away from using an intitrd=
 (I am building my own distribution based on CLFS x86_64 multilib).</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>I used cfdisk to partition both of the /dev/md[01] dev=
ices, and I obtained /dev/md0p[123] and /dev/md1p[12]. The plan is to use /=
dev/md0p1 as a RAID1 root partition, and have the system boot from /dev/md0=
.. I formatted /dev/md0p1 as</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>&gt; mk2efs -t ext4 -L OS /dev/md0p1</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>To this point, things went smoothly. mdadm -D... and m=
dadm -E... did report back working devices as intended. Then mounted /dev/m=
d0p1 on a directory called /root/os, and I did</DIV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>&gt; grub-install --root-directory=3D/root/os /dev/md0=
</DIV>
<P class=3DplainMail>or</DIV>
<P class=3DplainMail>&gt; grub-install --root-directory=3D/root/os "md0"</D=
IV>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>and I got a warning and an&nbsp;error message: "Embedd=
ing area is too small for core.img." and "Embedding is not possible, but th=
is is required when the root device is on a RAID array or LVM volume."</DIV=
>
<P class=3DplainMail>&nbsp;</DIV>
<P class=3DplainMail>What did I do wrong, and how do I fix it? Thanks ahead=
,</DIV>
<P class=3DplainMail>Tibor</DIV></td></tr></table>
--0-696638304-1262716242=:34440--




--===============0145616295==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Grub-devel mailing list
Grub-devel@gnu.org
http://lists.gnu.org/mailman/listinfo/grub-devel

--===============0145616295==--
