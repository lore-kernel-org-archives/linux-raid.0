From: "Nicolas" <nm-ml@fingerprint.fr>
Subject: System keep booting in degradedmode
Date: Mon, 25 Nov 2002 11:40:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NFEBKDECMMGIAKCMGJGDCEPKDNAA.nm-ml@fingerprint.fr>
References: <20021125102030Z262826-22911+2107@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021125102030Z262826-22911+2107@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey list

I want to get RAID1 running on a system currently running with no RAID.
I followed the RAID howto
I added one more disk and created a raidtab file with my currently running
disk as failed-disk. I made my raid device on my new disk, gave him a
filesystem, dumped my currently running disk on it, modified lilo.conf, ran
lilo, and rebooted on the raid disk. It worked great. According to
/proc/mdstat, My raid disk was OK, in degraded mode. I changed my
failed-disk into a raid-disk in the raidtab file, and raidhotadd(ed) my old
disk in the array. Again, it worked fine, and after reconstruction, the raid
array was no longer in degraded mode, and working fine (still according to
/proc/mdstat).
My problem is, each time I reboot, the raid is in degraded mode again, as if
I had never modified the raidtab. If I raidhotadd my old disk, it will be OK
again, until the next reboot, and so on.
Does anybody know what's wrong?

Thanks

Nicolas

