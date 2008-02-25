From: Richard Ray <rray@mstc.state.ms.us>
Subject: Kernel panic on RAID1 root after upgrade
Date: Mon, 25 Feb 2008 08:53:57 -0600 (CST)
Message-ID: <Pine.LNX.4.64.0802250840060.27674@rray.drdc.mstc.ms.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've run Fedora Core 6 for some time with root RAID1.
I upgraded to Fedora 7 and I get a kernel panic when it's time to assemble 
the RAID.



# cat /etc/mdadm.conf
ARRAY /dev/md0 level=raid1 uuid=1fa1fdf3:bb7ae68c:e164df71:0c6526f9 
auto=part
ARRAY /dev/md1 level=raid1 uuid=6f20b496:270786f5:4ca77094:9a84ab44 
auto=part
ARRAY /dev/md2 level=raid1 uuid=346dca9c:a2255bf8:72c4ec00:ed6a3e10 
auto=part

# cat /etc/fstab
/dev/md0                /                       ext3    defaults        1 1
none                    /dev/pts                devpts  gid=5,mode=620  0 0
none                    /proc                   proc    defaults        0 0
none                    /dev/shm                tmpfs   defaults        0 0
/dev/md1                /var                    ext3    defaults        1 2
/dev/md2                swap                    swap    defaults        0 0



If I try to boot with kernel-2.6.23.15-80.fc7 I get a panic.
If I boot with kernel-2.6.20-1.2962.fc6 the system works.
It's a production machine so I can only work at night.
Any suggestions?

Thanks
Richard Ray
