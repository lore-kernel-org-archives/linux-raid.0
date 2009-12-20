From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Booting from RAID1
Date: Sat, 19 Dec 2009 22:43:45 -0800
Message-ID: <4877c76c0912192243x5d7281begc9a94242d476a20f@mail.gmail.com>
References: <E7.83.01470.A77BD2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E7.83.01470.A77BD2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 19, 2009 at 9:34 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>
> Hey, everyone,
>
> =A0 =A0 =A0 =A0It's me again. =A0Well, while I am still going to keep=
 small offline
> drive backups for my boot drives on the servers, I have decided to re=
place
> the very small boot drives with some slightly larger RAID1 arrays. =A0=
To that
> end, I've looked around the web for some good advice, and the best I =
have
> found matching my system configuration seems to be this howto:
>
> http://www.linuxhowtos.org/System/raid.htm
>
> =A0 =A0 =A0 =A0I am a little unsure of one section, however. =A0In th=
e section he
> labels "Fix up initrd" he is suggesting I change the initrd in order =
to
> allow booting from an md array rather than a sata drive. =A0I thought=
 all 2.6
> kernels supported booting from an array directly ( No? ). =A0Also, bo=
th of
> these systems will have one PATA drive and one SATA ( seen as a "SCSI=
"
> /dev/sdx drive ) drive in the RAID 1 arrays. =A0Does that make a diff=
erence?
>
> =A0 =A0 =A0 =A0I will have three RAID 1 arrays: MD1 containing /boot =
on the first
> partition, MD2 containing / on the second partition, and MD3 containi=
ng the
> swap on the third partition of both drives. =A0One of the systems wil=
l also
> have an NTFS partition on each drive for booting Windows - rarely use=
d. =A0I
> will be using grub as the bootloader.
>
> =A0 =A0 =A0 =A0Any further advice?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Advice point 1; read my howto: http://wiki.tldp.org/LVM-on-RAID  If
you see anything that doesn't work, let me know so I can fix it.

Advice point 2; which my howto should mention: For boot devices you'll
probably want to use the 1.0 mdadm label format (not 1.1 or 1.2, which
are the same but change where the label is stored) for just the boot
raid 1.0 only.  It will also mention some things you should be extra
careful about...

Like mounting the bare devices in that raid set by mistake.

Oh, and you'll also very likely want grub to read the /boot
filesystem, which is why it must be on a partition followed by the
raid header, instead of a partition containing a raid header and raid
protected partition.  That use is OK since grub operates read-only.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
