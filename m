From: Sandro Dentella <sandro.dentella@tin.it>
Subject: mdadm: hot add failed ... lun0/part6: No space left on device
Date: Fri, 30 Jan 2004 13:32:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040130123211.GA10754@e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
  while trying to substitute a failed disk, I'm using the command:  

    # mdadm /dev/md1 --add /dev/ide/host0/bus1/target0/lun0/part6

  but I get:

  mdadm: hot add failed for /dev/ide/host0/bus1/target0/lun0/part6: No space left on device

  What does it mean?

  I don't know how to interpret it. I thought it was the partition that
  is not same dime as the other one (disks are different) but the partition
  I'm adding is bigger... as you can see further on.

  I noticed that the 2 disks are not seen in the same way, as if the second
  is not in LBA mode:

	cat /proc/ide/hda/model
	MODEL: MAXTOR 6L040J2
	GEOMETRY:
	cat /proc/ide/hda/geometry
	physical     77557/16/63
	logical      4866/255/63

	cat /proc/ide/hdc/model
	MODEL: Maxtor 6E040L0
	GEOMETRY:
	cat /proc/ide/hdc/geometry
	physical     79656/16/63
	logical      79656/16/63

###########  mdstat ##########################################################
    root@argo-cd root # cat /proc/mdstat 
    Personalities : [raid1] 
    read_ahead 1024 sectors
    md0 : active raid1 hdc1[1] ide/host0/bus0/target0/lun0/part1[0]
	  24000 blocks [2/2] [UU]

    md1 : active raid1 ide/host0/bus0/target0/lun0/part6[0]
	  2048192 blocks [2/1] [U_]

    md2 : active raid1 ide/host0/bus0/target0/lun0/part7[0]
	  36491520 blocks [2/1] [U_]

    unused devices: <none>


###########  fdisk - parted ##################################################
    And here are the partition tables of the disks:

root@argo-cd root # parted /dev/hda print
Disk geometry for /dev/ide/host0/bus0/target0/lun0/disc: 0.000-38172.750 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031     23.532  primary   ext2        raid
2         23.533  38170.063  extended              lba
5         23.563    533.408  logical   linux-swap  
6        533.439   2533.688  logical   reiserfs    raid
7       2533.720  38170.063  logical   reiserfs    raid



root@argo-cd root # parted /dev/hdc print
Disk geometry for /dev/ide/host0/bus1/target0/lun0/disc: 0.000-39205.687 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031     23.625  primary   ext2        raid
2         23.625  39205.687  extended              lba
5         23.656    533.531  logical               
6        533.562   2536.242  logical               raid
7       2536.273  39205.687  logical               raid

Thanks in advance
sandro
*:-)


-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
