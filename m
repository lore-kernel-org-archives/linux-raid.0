From: Raffaele Cicchese <cicchese@unipr.it>
Subject: Two disks lost?
Date: Tue, 16 Mar 2004 15:52:30 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0403161539010.31174-100000@galileo.fis.unipr.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I'm having troubles with an IDE raid5 software, here the situation:
hda  ->  System disk (primary   IDE0)
hdb  ->  Raid disk   (secondary IDE0)
hdc  ->  Raid disk   (primary   IDE1)
hdd  ->  Raid disk   (secondary IDE1)

From the host running Debian woody:
kilauea@root:~# grep "{ DriveReady SeekComplete Error }" /var/log/kern.log
...
/var/log/kern.log:Mar 16 11:42:21 kilauea kernel: hdb: dma_intr: 
error=0x40 { UncorrectableError }, LBAsect=6, sector=6
/var/log/kern.log:Mar 16 11:42:21 kilauea kernel: hdb: dma_intr: 
status=0x51 { DriveReady SeekComplete Error }
...
/var/log/kern.log:Mar 15 17:05:28 kilauea kernel: hdc: dma_intr: 
error=0x40 { UncorrectableError }, LBAsect=4, sector=4 
/var/log/kern.log:Mar 15 17:05:28 kilauea kernel: hdc: dma_intr: 
status=0x51 { DriveReady SeekComplete Error }
...
kilauea@root:~# cat /proc/mdstat   
Personalities : [raid5] 
read_ahead not set
unused devices: <none>

It seems to me that two disk've gone (hdb and hdc), what should I do to 
recover data?

Thanks
Raffaele

-- 
      RAFFAELE CICCHESE	
    Universita' di Parma	Phone:     +39-0521-906402	 
Centro di Calcolo Elettronico	Fax:       +39-0521-905469 
Parco Area delle Scienze, 17A	Web:   www.unipr.it/%7Eraffaele
     43100  Parma ITALY         

