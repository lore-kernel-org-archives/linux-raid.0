From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: mdadm: Invalid Argument ("cannot start dirty degraded array")
Date: Tue, 9 Nov 2004 11:31:57 -0500
Message-ID: <200411091632.iA9GW2N16673@www.watkins-home.com>
References: <m3ekj3f16q.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3ekj3f16q.fsf@bfnet.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Wuertele' <dave-gnus@bfnet.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Someone had a similar problem a few days ago.

Try stopping the array, then starting it.
mdadm -S /dev/md0
mdadm -A /dev/md0 --scan

Also, test the failed disk with this command:
dd if=/dev/hdp of=/dev/null bs=1024k

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Wuertele
Sent: Tuesday, November 09, 2004 11:16 AM
To: linux-raid@vger.kernel.org
Subject: mdadm: Invalid Argument ("cannot start dirty degraded array")

I have a gentoo system (kernel 2.6.8-gentoo-r3) with a 7 drive RAID5
array.  Recently that array went down, and I was advised by the list
to try mdadm.  I was unsuccessful, but perhaps someone here can advise
me where I went wrong.

When I boot, I see the "Starting up RAID devices: ... * Trying
md0... [ !!FAILED ]" and the system drops me to the shell.  I type:

  # cat /proc/mdstat
  Personalities : [raid1] [raid5]
  md0 : inactive hdm4[0] hde2[6] hdo2[5] hdh2[4] hdf2[3] hdg2[2]
        1464789888 blocks
  unused devices: <none>

OK, the array is missing partition hdp2.  dmesg says it has an invalid
superblock:

  # dmesg | grep hdp
      ide7: BM-DMA at 0xd808-0xd80f, BIOS settings: hdo:DMA, hdp:DMA
  hdp: WDC WD2500JB-00GVA0, ATA DISK drive
  hdp: max request size: 1024KiB
  hdp: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA
(100)
  md: invalid raid superblock magic on hdp2
  md: hdp2 has invalid sb, not importing!
  Adding 64220k swap on /dev/hdp1.  Priority:-2 extents:1

I didn't see any indication that there is anything wrong with the hdp
drive.  Here is my /etc/mdadm.conf file:

  # cat /etc/mdadm.conf
  DEVICE partitions
  ARRAY /dev/md0 level=raid5 num-devices=7
UUID=d312c423:e2eeeff5:3401806f:ab10e3c
 
devices=/dev/ide/host2/bus0/target0/lun0/part2,/dev/ide/host2/bus0/target1/l
un0/part2,/dev/ide/host2/bus1/target0/lun0/part2,/dev/ide/host2/bus1/target1
/lun0/part2,/dev/ide/host6/bus0/target0/lun0/part4,/dev/ide/host6/bus1/targe
t0/lun0/part2

Since /proc/mdstat reports that six of the seven drives are already
assembled, I tried running as-is:

  # mdadm --run /dev/md0
  mdadm: failed to run array /dev/md0: Invalid argument
  # mdadm -v --run --force /dev/md0
  mdadm: failed to run array /dev/md0: Invalid argument

Hmm... not very descriptive.  I looked at the end of dmesg again for
more hints:

  # dmesg | tail -18
  md: pers->run() failed ...
  raid5: device hdm4 operational as raid disk 0
  raid5: device hde2 operational as raid disk 6
  raid5: device hdo2 operational as raid disk 5
  raid5: device hdh2 operational as raid disk 4
  raid5: device hdf2 operational as raid disk 3
  raid5: device hdg2 operational as raid disk 2
  raid5: cannot start dirty degraded array for md0
  RAID5 conf printout:
   --- rd:7 wd:6 fd:1
   disk 0, o:1, dev:hdm4
   disk 2, o:1, dev:hdg2
   disk 3, o:1, dev:hdf2
   disk 4, o:1, dev:hdh2
   disk 5, o:1, dev:hdo2
   disk 6, o:1, dev:hde2
  raid5: failed to run raid set md0
  md: pers->run() failed ...

Any suggestions?
Thanks,
Dave

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

