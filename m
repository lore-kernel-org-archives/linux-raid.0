From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Thu, 28 Aug 2014 14:04:52 -0700
Message-ID: <CAH_2Ghet=gxp9XH7E9BYP=2CAyEuQd36uJO_LcRyOMDzpsqB8Q@mail.gmail.com>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
	<53E96C21.2050309@nuclearwinter.com>
	<53E9AC63.1020809@gmail.com>
	<BLU436-SMTP2487F2FA5F4B1A1A1B1E87B98EA0@phx.gbl>
	<CAH_2GhfBKiJAT=+zCFH0_xkmyTfWFi=c-F+z8rwL1x++UwU+KA@mail.gmail.com>
	<CAH_2Ghc+M2dCQBs3iRXYPZwKAsvY-TbS852VxhReT4k8HBQkQQ@mail.gmail.com>
	<CAH_2GhcVeVv7Uh5Gw9nwmkzisABuTkHPK9hXUxzb=EPkBNu+dQ@mail.gmail.com>
	<53ECEB42.8080400@nuclearwinter.com>
	<CAH_2Ghd5WZLhhct9drM1kgsNiYAQrWXeNxarSaST18PcuYc7HA@mail.gmail.com>
	<53ECFA65.7050500@nuclearwinter.com>
	<CAH_2GheHG7N7PY22kxeDnLeCkmXg8AsHu6t_NX+Mi9PxPYfk2Q@mail.gmail.com>
	<53F226C6.5030101@nuclearwinter.com>
	<CAH_2GhcwHszr75bbDq2aWRnnF8-ttpGERKE=CKt=Nri3ue9row@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2GhcwHszr75bbDq2aWRnnF8-ttpGERKE=CKt=Nri3ue9row@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: Can Jeuleers <can.jeuleers@gmail.com>, rm@romanrm.net, linux-raid@vger.kernel.org, "Wilson, Jonathan" <piercing_male@hotmail.com>
List-Id: linux-raid.ids

Solved.  The below link to the Gentoo forums is my formal write up.  I
hope this info can help those who follow me in the sleep drive
adventures. Now I am off to take a nap.
https://forums.gentoo.org/viewtopic-t-997086.html

The raw text, just encase the above link does not work:
Success!!

Why?
I wanted to put my DM software based RAID6 to sleep when not in use.
At 10 watts per drive, it adds up! I did not want to wait 10 seconds
per drive, in series for the array to come to life. I was tired of my
windows desktop hanging while waiting for a simple directory look up
on my NAS.

Disclaimer:
Do not come crying to me when you destroy a hard drive, loose all your
data, fry a power supply, or cause a small country to be erased from
the face of the Earth.

The key points covered below:
Drive Controller
Bcache
Inotify

Drive Controller
My server/NAS was running 3X LSI SAS 1068e controllers to control my 7
drives RAID 6. Turns out that the cards are hard coded to spin up in
series. No way to get around it, it just is. This happens to apply to
ANY card running the LSI 1068e chipset, such as a Dell Perc 6/i, or HP
P400. This may even apply to all LSI based cards. To make matters
worse, the cards are smart and will only spin one drive up at a time
across all 3 cards. My 7 disk RAID 6 was taking 50 seconds to spin up
(10 seconds per drive). This was dropped to 40 seconds when I moved 1
drives to the on board SATA controller. That was my first clue. Thanks
to the Linux-Raid group mailing list for the help isolating this one.

So I was on the Internets looking for a new, cheap, 12~16 port SATAII
controller card. I found a very strange card on ebay. A "Ciprico Inc.
RAIDCore" 16-port card. I cant even find any good pictures or links to
add to this post so you can see it. It basically has 4 Marvell
controllers and a pci-e bridge strapped onto a single card. No brains,
no nothing. Just a pure, dumb controller with out any spin up
stupidity. Same chipset (88SE6445) found on some RocketRAID cards. It
was EXACTLY what I was looking for. At a cost of $60 I was thrilled.
In Linux is shows up as a bridge + controller chips:

Code:
07:00.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI
Express Switch (rev 0d)
08:02.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI
Express Switch (rev 0d)
08:03.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI
Express Switch (rev 0d)
08:04.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI
Express Switch (rev 0d)
08:05.0 PCI bridge: Integrated Device Technology, Inc. PES24T6 PCI
Express Switch (rev 0d)
09:00.0 SCSI storage controller: Marvell Technology Group Ltd.
88SE6440 SAS/SATA PCIe controller (rev 02)
0a:00.0 SCSI storage controller: Marvell Technology Group Ltd.
88SE6440 SAS/SATA PCIe controller (rev 02)
0b:00.0 SCSI storage controller: Marvell Technology Group Ltd.
88SE6440 SAS/SATA PCIe controller (rev 02)
0c:00.0 SCSI storage controller: Marvell Technology Group Ltd.
88SE6440 SAS/SATA PCIe controller (rev 02)

Bcache https://www.kernel.org/doc/Documentation/bcache.txt
Now that I have the total spin up time down from 50 seconds
((number_of_drives *10) -2) to 10 seconds. I was able to address the
reaming 10 seconds using caching. In this case I am using bcache. My
operating system disks 2X are OCZ Deneva 240GB SSD's set up in a basic
mirror. I partitioned these drives out and used 24GB's as a caching
device for my raid. Quickly found out that bcache is unstable on the
3.16 kernel and was forced back to the 3.14lts kernel. After I landed
on the 3.14.15 kernel everything is running great. The basic bcache
setting work, but I wanted more:
Code:
#Setup bcache just the way I like it, hun-hun, hun-hun
#Get involved in read and write activities
echo "writeback" > /sys/block/bcache0/bcache/cache_mode

#Allow the bcache to put data in the cache, but get it out as fast as possible
echo "0" > /sys/block/bcache0/bcache/writeback_percent
echo "0" > /sys/block/bcache0/bcache/writeback_delay
echo $((16*1024)) > /sys/block/bcache0/bcache/writeback_rate

#Clean up jerky read performance on file that have never been cached.
echo "16M" > /sys/block/bcache0/bcache/readahead

I put all the above code in rc.local so my system picks them up on
boot. Writes still need to wake the array, but reads from cache don't
even wake up the drives.

Code:
root@nas:/data# time (dd if=/dev/zero of=foo.dd bs=4096k count=16 ; sync)
16+0 records in
16+0 records out
67108864 bytes (67 MB) copied, 0.0963405 s, 697 MB/s

real    0m10.656s  #######Array spin up time#########
user    0m0.000s
sys     0m0.128s

root@nas:~# ./sleeping_raid_status.sh
/dev/sdc standby
...
/dev/sdd standby
root@nas:/data#  time (dd if=foo.dd of=/dev/null iflag=direct)
131072+0 records in
131072+0 records out
67108864 bytes (67 MB) copied, 0.118975 s, 564 MB/s

real    0m0.121s  ########Array never even woke up#########
user    0m0.024s
sys     0m0.096s
root@nas:~# ./sleeping_raid_status.sh
/dev/sdc standby
/dev/sdj standby
...

Inotify
Wait... The array did not spin up because it read from cache?! Not
good, but working exactly as expected. I have the file metadata in
cache, but what happens when I want to read the file... 10 seconds
later... Normally when I find a media file, I want to
read/watch/listen to it. I accessed the metadata; preemptive spin up?
Time for a fun script using inotify.

I actually took this script one step further then just preemptive spin
up and have it do all drive power management. Turns out different
drive manufactures interpret `hdparm -S 84 $DRIVE` (Go to sleep in 7m)
differently. This whole NAS was built on the cheap and I have 4
different types of drives in my array.

Code:
#!/bin/bash
WATCH_PATH="/data"
ARRAY_NAME="data"
SLEEPING_TIME_S="600"
ARRAY=`ls -la /dev/md/$ARRAY_NAME | awk -F"../" '{print $5}'`

PARTS=`ls /sys/block/$ARRAY/slaves | sed 's/[^a-z]*//g'`

set -m

while [ 1 ];do
  inotifywait $WATCH_PATH -qq -t $SLEEPING_TIME_S
  if [ $? = "0" ];then
    #echo -n "Start waking: "
    for i in $PARTS; do
      (hdparm -S 0 /dev/$i) &
    done
    #echo "Done"
  else
    #echo -n "Make go sleep: "
    for i in $PARTS; do
      STATE=`hdparm -C /dev/$i | grep "drive state is" | awk '{print $4}'`
      #Really should check that the array is not doing something block
related, like a check or rebuild
      if [ "$STATE" != "standby" ];then
        hdparm -y /dev/$i > /dev/null 2>&1
      fi
    done
    #echo "Done"
  fi
  sleep 1s
done

A few other key points have been addressed in this thread. There is
much greater details in the below posts:
Spinning drives up/down puts wear on drives, but it is more cost
effective to sleep the drives and wear them out then it is to pay for
the power.
Spinning up X drives at once puts a huge load on the PSU (Power Supply
Unit). According to Western Digital, their 7200RPM drives spike at 30
watts during spin up. You have been warned.
Warning, formatting a drive for bcache will remove ALL your data.
There is no way to remove bcache with out reformatting the device.
5400RPM drives take about 10 seconds to spin up. 7200RPM take about 14
seconds to spin up.
