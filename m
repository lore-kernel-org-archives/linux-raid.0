From: Tomasz Chmielewski <tch@wpkg.org>
Subject: Re: not able to resize/grow RAID-1 (beyond 1 TB?)
Date: Sat, 14 Jan 2012 22:15:59 +0100
Message-ID: <4F11F08F.4070706@wpkg.org>
References: <4F109576.5090604@wpkg.org> <4F11E4F4.1030309@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F11E4F4.1030309@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/14/2012 09:26 PM, Stefan /*St0fF*/ H=FCbner wrote:
> Hi Tomasz,
>
> at first: if you had 1TB drives before, dd'ed them to the new 3TB dri=
ves
> and changed the partitioning scheme accordingly - that all looks OK.
> The weird thing here is that 1TB disks never had 1024GiB, but 931GiB.
> So the reshape has already happened to "the system's maximum".
>
> I do suspect you have a 32bit system and mdadm is not the latest vers=
ion?

No, the system was 64 bit from the very beginning; mdadm may not be the=
=20
latest one, but is far from being obsoletes, too (Debian Squeeze).

The issue is actually solved now.

What I had to do was:

mdadm /dev/md2 -f /dev/sdb3
mdadm /dev/md2 -r /dev/sdb3
# not necessarily 10 MB needs cleaning, but it's a small number...
dd if=3D/dev/zero of=3D/dev/sdb3 bs=3D1M count=3D10
mdadm /dev/md2 -a /dev/sdb3
# wait till it syncs, and do the same for /dev/sda3
reboot


If I did the same without dd if=3D/dev/zero, it somehow didn't want to=20
work and /dev/md2 was still only 1 TB big.
Unless I've messed up somewhere!



--=20
Tomasz Chmielewski
http://wpkg.org


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
