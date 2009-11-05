From: KueiHuan Chen <kueihuan.chen@gmail.com>
Subject: Data corruption after raid migration (raid5 to raid6 in 2.6.31 with
	mdadm 3.1)
Date: Thu, 5 Nov 2009 17:54:09 +0800
Message-ID: <788014650911050154x1861b292i3ab221a9dec7adb0@mail.gmail.com>
Reply-To: khchen@synology.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

  I encounter a little problem when perform the raid5 to raid6
migration. The result is data corruption if i stop the raid while
reshape and then reassemble the raid. Here is the operation oder:

Environment : linux-2.6.31 . mdadm 3.1

=2E/mdadm -C /dev/md2 -R -amd -l5 -n4 /dev/sd[cdef]3 -z 1000000
mkfs.ext3 /dev/md2
mount /dev/md2 /volume1/
cp /bin/* /volume1/
=2E/mdadm /dev/md2 -a /dev/sdg3
=2E/mdadm --grow --level=3D6 --layout=3Ddefault --backup-file=3D/root/b=
ak2 /dev/md2
umount /dev/md2
=2E/mdadm -S /dev/md2  (Stop it before reshape end)
=2E/mdadm -A /dev/md2 --backup-file=3D/root/bak2 /dev/sd[cdefg]3
mount /dev/md2 /volume1=C2=A0 <--- This will cause an error that file
system could not be mounted.

  The interesting thing is if i don't stop the raid while reshape. The
data will not corruption. Is it means the operations not permitted
while the reshape process ?

Thanks.

Best Regards,
KueiHuan-Chen
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
