From: Hubert Verstraete <hubskml@free.fr>
Subject: RAID5 losing initial synchronization on restart when one disk is
 spare
Date: Wed, 04 Jun 2008 12:13:45 +0200
Message-ID: <48466AD9.5@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

According to mdadm's man page:
"When creating a RAID5 array, mdadm will automatically create a degrade=
d
array with an extra spare drive. This is because building the spare
into a degraded array is in general faster than resyncing the parity on
a non-degraded, but not clean, array. This feature can be over-ridden
with the --force option."

Unfortunately, I'm seeing a kind of bug when I create a RAID5 array wit=
h=20
an internal bitmap, then stop the array before the initial=20
synchronization is done and restart the array.

1=B0 When I create the array with an internal bitmap:
mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -b internal -R /dev/sd?
I see the last disk as a spare disk. After the restart of the array, al=
l=20
disks are seen active and the array is not continuing the aborted=20
synchronization!
Note that I did not use the --assume-clean option.

2=B0 When I create the array without a bitmap:
mdadm -C /dev/md_d1 -e 1.2 -l 5 -n 4 -R /dev/sd?
I see the last disk as a spare disk. After the restart of the array, th=
e=20
spare disk is still a spare disk and the array continues the=20
synchronization where it had stopped.

In the case 1=B0, is this a bug or did I miss something?
Secondly, what could be the consequences of this non-performed=20
synchronization ?

Kernel version: 2.6.26-rc4
mdadm version: 2.6.2

Thanks,
Hubert
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
