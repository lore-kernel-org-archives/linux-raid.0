From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Dumb questions about mdadm #1 - replacing broken disks - "slot"
 reuse?
Date: Sun, 20 Sep 2009 18:55:26 +0200
Message-ID: <slrnhbcnjv.eul.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <4AB37978.5030403@Calva.COM>
 <slrnhb7mt1.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again,

the issue is btw. easily reproducible:

# dd if=/dev/zero of=/tmp/foo1 bs=1k count=100k
102400+0 records in
102400+0 records out
104857600 bytes (105 MB) copied, 0,18648 s, 562 MB/s
# losetup /dev/loop0 /tmp/foo1 
# mdadm --create -e 1.1 -l raid1 -n 2 -a md /dev/md8 /dev/loop0 missing
mdadm: array /dev/md8 started.
# dd if=/dev/zero of=/tmp/foo2 bs=1k count=100k
102400+0 records in
102400+0 records out
104857600 bytes (105 MB) copied, 0,196626 s, 533 MB/s
# losetup /dev/loop1 /tmp/foo2 
# mdadm --add /dev/md8 /dev/loop1
mdadm: added /dev/loop1
# grep -A1 ^md8 /proc/mdstat 
md8 : active raid1 loop1[2] loop0[0]
      102392 blocks super 1.1 [2/2] [UU]
# mdadm -E /dev/loop0 | tail -2
   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)
You have new mail in /var/mail/root
# mdadm -E /dev/loop1 | tail -2
   Device Role : spare
   Array State : AA ('A' == active, '.' == missing)
# 


regards
   Mario
-- 
<jv> Oh well, config
<jv> one actually wonders what force in the universe is holding it
<jv> and makes it working
<Beeth> chances and accidents :)

