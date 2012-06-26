From: =?koi8-r?B?68/T1NnSxdcg4czFy9PBzsTSIOHMxcvTxcXXyd4=?=
	<a.kostyrev@serverc.ru>
Subject: recover linear mode raid howto
Date: Tue, 26 Jun 2012 17:26:53 +1100
Message-ID: <213B51F00051AE48A9F0E112880177178F7A55@Delta.sc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!
I'm trying to figure out how one can recover from linear mode crash.
I'm aware that from this type of mode I can recover only part of data, =
there's no redundancy in linear mode and that's ok for me.
I'm ok with part of it.

so far I'm trying to get it work in VM for now.


I've added two 50M disks to my VM.

and partiotioned them like this:
Device Boot      Start     End      Blocks  Id  System
/dev/vdb1        2048      102399   50176   fd  Linux raid autodetect
Device Boot      Start     End      Blocks  Id  System
/dev/vdc1        2048      102399   50176   fd  Linux raid autodetect

mdadm --create --verbose /dev/md0 --level linear --raid-disks 2 /dev/vd=
b1 /dev/vdc1
mdadm --detail --scan >> /etc/mdadm/mdadm.conf

mkfs.xfs /dev/md0=20
mount /dev/md0 /mnt/linear/

mkdir /mnt/linear/etc
mkdir /mnt/linear/etc2
mkdir /mnt/linear/etc3

filled with some data
cp -r /etc/* /mnt/linear/etc/
cp -r /etc/* /mnt/linear/etc2/
cp -r /etc/* /mnt/linear/etc3/

df -h /dev/md0
=46ilesystem            Size  Used Avail Use% Mounted on
/dev/md0               92M   69M   23M  76% /mnt/linear

then I remove one disk from my VM

umount /mnt/linear
mdadm --stop /dev/md0

I've added another clear disk image 50M.

make partitions on new disk
sfdisk -d /dev/vdb | sfdisk /dev/vdc

how should I proceed ?

thanks a lot!

--
=F3 =D5=D7=C1=D6=C5=CE=C9=C5=CD,
=EB=CF=D3=D4=D9=D2=C5=D7 =E1=CC=C5=CB=D3=C1=CE=C4=D2
=D3=C9=D3=D4=C5=CD=CE=D9=CA =C1=C4=CD=C9=CE=C9=D3=D4=D2=C1=D4=CF=D2
=FA=E1=EF "=F3=C5=D2=D7=C5=D2-=E3=C5=CE=D4=D2"
=D4=C5=CC.: (423) 262-02-62 (=C4=CF=C2. 2037)


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
