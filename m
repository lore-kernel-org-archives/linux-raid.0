From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Wrong array assembly on boot?
Date: Sat, 22 Jul 2017 21:39:25 +0300
Message-ID: <59739BDD.30307@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings!

I have a mirror RAID with two devices (sdc1 and sde1). It's not a root
partition, just a RAID with some data for services running on this
server. (I'm running Debian Jessie x86_64 with a 4.1.18 kernel.) The
RAID is listed in /etc/mdadm, and it has an external bitmap in /RAID .

One of the devices in the RAID (sdc1) "fell off" - it disappeared from
the system for some reason. Well, I thought, I have to reboot to get the
drive back, and then re-add it.

That's what I did. After the reboot, I saw a degraded array with one
drive missing, so I found out which one , and re-added it back.

Later, I noticed that I'm missing some data, and thinking about this
situation led me to understanding what happened. After a reboot, the
system tried to assemble my arrays; it found sdc1 first (the one that
disappeared), assembled a degraded array with only this drive, and
started it. When I re-added the second drive, I've overwritten
everything that happened between those events.



Now I'm trying to understand why this happened and what am I supposed to
do in this situation to handle it properly. So now I have a lot of
questions boiling down to "how should booting with degraded arrays be
handled?"

- Why did mdadm not notice that the second drive is "newer"? I thought
there were timestamps in the devices and even in the bitmap!..

- Why did it START this array?! I thought if a degraded array is found
at boot, it's supposed to be assembled but not started?.. At least I
think that's how it used to be in Wheezy (before systemd?).

- Googling revealed that if a degraded array is detected, the system
should stop booting and ask for a confirmation in the console. (Only for
root partitions? And only before systemd?..)

- My services are not going to be happy either way. If the array is
assembled but not run, they will have data missing. If the array is
assembled and run, it's even worse - they will start with outdated data!
How is this even supposed to be handled?.. Should I add dependencies on
mounting a specific mountpoint in each service definition?.. Am I wrong
in thinking that mdadm should have detected that the second drive is
"newer" and assemble the array just like it was before, thus avoiding
all those problems easily?.. Especially considering that the array on
the "new" drive already consists of only one drive, which is "not as
degraded" and would be fine to run, compared to the array on the "old"
drive which was not stopped properly and only now learns about one of
the drives missing? Maybe this behaviour is already changed in the newer
versions?..


-- 
darkpenguin
