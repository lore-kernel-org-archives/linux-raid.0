From: =?iso-8859-1?Q?Jes=FAs_Rojo_Mart=EDnez?=
	<jrojomartinez@mi.madritel.es>
Subject: Posible bug on RAID 1 driver
Date: Wed, 23 Feb 2005 22:21:56 +0100
Message-ID: <20050223212156.GA11589@nerv.homelinux.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>, Jakob =?iso-8859-1?Q?=D8stergaard?= <jakob@ostenfeld.dk>, Neil Brown <neilb@cse.unsw.edu.au>, Miguel de Icaza <miguel@ximian.com>, Gadi Oxman <gadio@netvision.net.il>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

  The Linux RAID crushes when recuntructing a disk.


  We have a RAID 1 disk over two active SATA disks and one spare SATA
disk.

  I was probing the RAID and I finded that the RAID ocasionally crashes.
I adjunt to this email the secuences of commands I wrote.

  When I swap one disk on the RAID, the spare becomes active and its
information is reconstructed. I do this repeatedly and all is well.

  But, sometimes, It crushes and the spare disk isn't reconstructed. The
/proc/mdstat informs that velocity is... 0 Kb/s!!! And is because this
that the system doesn't respond correctly (really the system responds,
but it doesn't write on the RAID, and the RAID doesn't umounts and when
I halt the system, it hungs waiting for the RAID).

  I use raidtools and mdadm tools, is for that I think the problem is in
the kernel driver, not in the tools or my secuence of commands.

  I use a 2.4.29 kernel (on a Debian sarge GNU/Linux).

  I am not familiarized with the source of that. Because of this I
report the bug to you.


  Please, acknowledge me about this email.

  Thanks a lot.


  Regards,

-- 

		--- Jesús Rojo Martínez. ---


P.D.: Sorry about my poor english.

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=BUG_MD_DISK

centralmad:~# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[1] sdb1[0] sdc1[2]
      999872 blocks [2/2] [UU]
      
unused devices: <none>
centralmad:~# DEVICE=/dev/sdd1 ; raidsetfaulty /dev/md1 $DEVICE ; raidhotremove /dev/md1 $DEVICE ; cat /proc/mdstat;                                               
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdb1[0] sdc1[2]
      999872 blocks [2/1] [U_]
      
unused devices: <none>
centralmad:~# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdb1[0] sdc1[2]
      999872 blocks [2/1] [U_]
      [==>..................]  recovery = 14.4% (145088/999872) finish=0.1min speed=72544K/sec
unused devices: <none>
centralmad:~# cat /proc/mdstat; raidhotadd /dev/md1 $DEVICE ; cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdb1[0] sdc1[1]
      999872 blocks [2/2] [UU]
      
unused devices: <none>
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[2] sdb1[0] sdc1[1]
      999872 blocks [2/2] [UU]
      
unused devices: <none>
centralmad:~# DEVICE=/dev/sdb1 ; raidsetfaulty /dev/md1 $DEVICE ; raidhotremove /dev/md1 $DEVICE ; cat /proc/mdstat; 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[2] sdc1[1]
      999872 blocks [2/1] [_U]
      
unused devices: <none>
centralmad:~# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[2] sdc1[1]
      999872 blocks [2/1] [_U]
      [======>..............]  recovery = 32.8% (328848/999872) finish=0.2min speed=54808K/sec
unused devices: <none>
centralmad:~# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[2] sdc1[1]
      999872 blocks [2/1] [_U]
      [===================>.]  recovery = 96.4% (964864/999872) finish=0.0min speed=56756K/sec
unused devices: <none>
centralmad:~# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[0] sdc1[1]
      999872 blocks [2/2] [UU]
      
unused devices: <none>
centralmad:~# cat /proc/mdstat; raidhotadd /dev/md1 $DEVICE ; cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdd1[0] sdc1[1]
      999872 blocks [2/2] [UU]
      
unused devices: <none>
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdb1[2] sdd1[0] sdc1[1]
      999872 blocks [2/2] [UU]
      
unused devices: <none>
centralmad:~# DEVICE=/dev/sdc1 ; raidsetfaulty /dev/md1 $DEVICE ; raidhotremove /dev/md1 $DEVICE ; cat /proc/mdstat; 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdb1[2] sdd1[0]
      999872 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (0/999872) finish=166.6min speed=0K/sec
unused devices: <none>
centralmad:~# cat /proc/mdstat; raidhotadd /dev/md1 $DEVICE ; cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdb1[2] sdd1[0]
      999872 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (0/999872) finish=166.6min speed=0K/sec
unused devices: <none>
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdc1[3] sdb1[2] sdd1[0]
      999872 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (0/999872) finish=166.6min speed=0K/sec
unused devices: <none>
centralmad:~# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 sdc1[3] sdb1[2] sdd1[0]
      999872 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (0/999872) finish=1166.5min speed=0K/sec
unused devices: <none>
centralmad:~#

--jRHKVT23PllUwdXP--
