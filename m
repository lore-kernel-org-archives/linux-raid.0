From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: raid-5 initiated as raid-4?
Date: Thu, 7 Feb 2013 18:08:59 +0100 (CET)
Message-ID: <4216250.12.1360256939673.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

I have a test vm on which I do some testing of md raid. Just tried

root@raidtest:~# mdadm --create /dev/md0 --level=3D5 --raid-devices=3D3=
 /dev/vd{b..d}
(wait a bit)
root@raidtest:~# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md0 : active raid5 vdf[5](S) vde[4](S) vdd[3] vdc[1] vdb[0]
      4191232 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [=
UUU]

ok, raid's up, but checking the data actually stored on disk on the hos=
t system shows:

root@smilla:/raid/libvirt/images# ls -l raidtest-{1..3}.qcow2
-rw-r--r-- 1 libvirt-qemu kvm     393216 Feb  7 18:06 raidtest-1.qcow2
-rw-r--r-- 1 libvirt-qemu kvm     393216 Feb  7 18:06 raidtest-2.qcow2
-rw-r--r-- 1 libvirt-qemu kvm 2146500608 Feb  7 18:06 raidtest-3.qcow2

Does this mean the raid-5 is actually initiated as a raid-4?

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
