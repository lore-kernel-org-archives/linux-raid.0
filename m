From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: how to turn down cpu usage of raid ?
Date: Mon, 2 Feb 2004 20:39:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402030139.i131dGi19663@dns1.watkins-home.com>
References: <021c01c3e9e2$d80b3640$0100a8c0@KARI>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <021c01c3e9e2$d80b3640$0100a8c0@KARI>
To: 'Matthew Simpson' <matthew@symatec-computer.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Load and CPU usage are 2 different things, but somehow related.  What is the
CPU load during this time?

From what I have seen, the RAID software md, whatever, uses almost no CPU.
So, I don't think it is a CPU issue.  Even with RAID5, the CPU load is very
low.  Even during a rebuild!

Use top to see cpu usage.
Use sar (man sar) for keeping a log of cpu load and a lot of other stuff.

"sar -d" to see disk usage.

Maybe you are swapping, this would be bad.  Add RAM if so.

I bet your 2 disks are the bottle neck.

If the RAID1 can be tuned, I don't know how.  But the first step is to
determine what the bottle neck is.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Matthew Simpson
Sent: Monday, February 02, 2004 6:18 PM
To: linux-raid@vger.kernel.org
Subject: how to turn down cpu usage of raid ?

Help!  I am having complaints from users about CPU spikes when writing to my
RAID 1 array.  Is there a way I can tune software RAID so that writing
updates doesn't interfere with other applications?  [can I nice the raid1d
process?]

Specifically I experience giant slowdowns in a hosted application whenever
someone unpacks a tar file or the like.  Load averages are 1.10 - 2.00
during writes, but 0.00 to 0.05 otherwise.

root@ns2:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 hdc1[1] hda1[0]
      78979200 blocks [2/2] [UU]

unused devices: <none>

root@ns2:~# cat /etc/raidtab
raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      4
        persistent-superblock   1
        device  /dev/hda1
        raid-disk       0
        device  /dev/hdc1
        raid-disk       1

This is a pentium IV 2.5GHz system with 1GB of RAM.
    IDE interface: PCI device 8086:24cb (Intel Corp.) (rev 1). -- 82820
Camino 2 chipset


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

