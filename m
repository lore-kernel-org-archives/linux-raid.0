From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: New RAID1 machine "No bootable media"
Date: Mon, 29 Mar 2010 19:29:39 -0700
Message-ID: <40b437201003291929h5fd760dcl7e19b18afd188f12@mail.gmail.com>
References: <5bdc1c8b1003280812i7e785215xd44928c8d746a2b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003280812i7e785215xd44928c8d746a2b0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Did you mark the partition as a bootable partition (using fdisk or
cfdisk, etc)? I encountered this problem very recently. It seems to
afflict 945G chipsets and it would not be unreasonable to think that
other Intel chipsets could have the same issue. Another example of
this:
http://www.vyatta.org/forum/viewtopic.php?t=3D1976

Can you boot off a livecd such as systemrescuecd and then use that to
boot off the hard drive (using the "disk1" boot option)?

Simon

On Sun, Mar 28, 2010 at 8:12 AM, Mark Knecht <markknecht@gmail.com> wro=
te:
> Hi,
> =A0 I brought up new hardware yesterday for my first RAID install. I
> followed this Gentoo page describing a software RAID1/LVM install:
>
> http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinstall.xml
>
> =A0 Note that I followed this page verbatim, even if it wasn't what I
> wanted, with exceptions:
>
> a) My RAID1 is 3 drives instead of 2
> b) I'm AMD64 Gentoo based.
> c) I used grub-static
>
> =A0I did this install mostly just to get a first-hand feel for how to
> do a RAID install and to try out some of the mdadm commands for real.
> My intention was to blow away the install if I didn't like it and do
> it again for real once I started to get a clearer picture about how
> things worked. For instance, this set of instructions used RAID1 on
> the /boot directory which I wasn't sure about.
>
> =A0 NOTE: THIS INSTALL PUTS EVERYTHING ON RAID1. (/, /boot, everythin=
g)
> I didn't start out thinking I wanted to do that.
>
> =A0 So, the first problem is that on the reboot to see if the install
> worked the Intel BIOS reports 'no bootable media found'. I am very
> unclear how any system boots software RAID1 before software is loaded=
,
> assuming I understand the Gentoo instructions. The instructions I use=
d
> to install grub where
>
> root (hd0,0)
> setup (hd0)
> root (hd1,0)
> setup (hd1)
> root (hd2,0)
> setup (hd2)
>
> but the system finds nothing to boot from. to me this sounds like BIO=
S
> so looking around I'm currently set up for compatibility but would
> think that switching to AHCI support would be a better long term
> solution. Any chance this setting is the root cause?
>
> =A0 I can boot from CD and assemble the /boot RAID
>
> livecd ~ # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>
> livecd ~ # mdadm --assemble /dev/md1 /dev/sda1 /dev/sdb1 /dev/sdc1
> mdadm: /dev/md1 has been started with 3 drives.
> livecd ~ # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md1 : active raid1 sda1[0] sdc1[2] sdb1[1]
> =A0 =A0 =A0112320 blocks [3/3] [UUU]
>
> unused devices: <none>
> livecd ~ # mdadm --misc --stop /dev/md1
> mdadm: stopped /dev/md1
> livecd ~ # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> unused devices: <none>
> livecd ~ #
>
>
> Everything I expect to see on /boot seems to be there when using ls.
>
> =A0 Note that one possible clue - when the Intel BIOS screen first
> comes up I see some hex digits flashing around in the lower right.
> I've not seen this before on other machines and I beleive the
> motherboard (DX58SO) does support some sort of RAID in hardware so
> maybe there's confusion there? I've not selected RAID in BIOS but
> possible it's trying to be too clever?
>
> =A0 Let me know what other info might be needed. I have concerns abou=
t
> this install and will likely blow it away today and do a new one but =
I
> figured maybe there's an opportunity to learn here before I do that.
>
> Cheers,
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
