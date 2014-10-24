From: <shane-kernel@csy.ca>
Subject: Help with raid1 to raid5 reshape after crash
Date: Fri, 24 Oct 2014 16:38:40 -0700
Message-ID: <001001cfefe3$a82538a0$f86fa9e0$@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-ca
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I was converting from a 2 disk raid1 array to a 4 disk raid5 (3+1s) in preparation to convert to a four disk raid6. I added the two additional component devices and did a:
Mdadm --grow /dev/md1 --level 5 --raid-devices 3
And off it went. I had a power failure a good ways in and now when the system boots, it runs the array, attempts to restart the reshape then disk IO locks up hard.

I figure it is disk IO rather than a complete system lockup as I have about 10 seconds of interactive shell before it locks. If I enter a dmesg command then that command will succeed. After the lockup, subsequent dmesg commands succeed (dmesg is in cache) but another command such as ls will lock up. Cat /proc/mdstat shows the reshape in progress but it doesn't actually progress beyond the point at which the system locks.

Booting from a USB stick, I tried:
Mdadm --assemble --readonly
But that too hangs the system.

Do I have any recourse beyond just recreating the array and restoring from backup? Kernel is 3.16.

Thanks,
Shane


Mdadm -D


