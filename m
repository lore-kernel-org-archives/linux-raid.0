From: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Subject: Re: Massive RAID-1 desync
Date: Sat, 25 Apr 2015 08:18:14 +0200 (CEST)
Message-ID: <1864016393.18733588.1429942694259.JavaMail.zimbra@laposte.net>
References: <1810942606.18204832.1429908469113.JavaMail.zimbra@laposte.net> <alpine.DEB.2.02.1504250601200.16871@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1504250601200.16871@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2015-04-25 06:02 +0200, Mikael Abrahamsson wrote:

> What kernel version are you running?

Linux 3.0.14.
mdadm 3.1.4 (2010-08-31)

> Some other information would be
> interesting as well, such as what /proc/mdstat is saying,

Good point. Curiously, nothing :

md1 : active raid1 sdd1[3] sdb1[0] sdc1[2] sda1[1]
      31463232 blocks [4/4] [UUUU]

> and anything from dmesg or similar logs leading up to this...

Too late, /var/log was on the root file system and lockd has 
since helpfully flooded the kernel ring buffer.
