From: "=?iso-8859-2?B?VmxhZGlt7XIgVPhlYmlja/0=?=" <trebicky@xhost.cz>
Subject: Recreating RAID from a healthy full disk
Date: Tue, 22 Jul 2003 09:53:05 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003f01c35026$48c5ae80$4500a8c0@cybernet.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

recently one of our two disks (set in RAID1) on our webhosting server g=
ot
faulty. Strange was, that even that the other was healthy, reading some
files crashed with IO errors. What I did was:
    1) I unset linux-raid-autodetect flags on all partitions of the hea=
lthy
disk
    2) Turned off the computer
    3) Unplugged the faulty disk
    4) Turned on the computer and booted directly from healthy disk
(/dev/hda, not /dev/md...)
Now I'm managing to get a new disk instead of the faulty one. I would l=
ike
to know what I'm supposed to do when I'll have it.
I guess I should repartition the new disk the same way as the old one, =
set
all those linux-raid-autodetect flags with fdisk. But how should I conv=
ince
raidtools to recreate raid synchronizing files from the healthy one to =
the
new one?

Thanks for any help! I'm really scared :(

Vladimir Trebicky


---
Odchoz=ED zpr=E1va mo=BEn=E1 neobsahuje viry.
Zkontrolov=E1no antivirov=FDm syst=E9mem AVG (http://www.grisoft.cz).
Verze: 6.0.502 / Virov=E1 b=E1ze: 300 - datum vyd=E1n=ED: 18.7.2003

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
