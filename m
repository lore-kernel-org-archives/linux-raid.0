From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 12:25:32 +0530
Message-ID: <WM67BE4064A5314b2eB4218F150486C3CD@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Folks,

I am trying to create RAID5 array using mdadm on kernel 2.6.15 as

# mdadm -Cv /dev/md0 --assume-clean --force --bitmap=/tmp/bitmap.txt -l5 -n4
/dev/sd{a,b,c,d}

But when I execute this command getting the following error:

mdadm: RUN_ARRAY failed: Cannot allocate memory

# dmesg shows

Apr 11 00:39:40 localhost kernel: md: bind<sda>
Apr 11 00:39:40 localhost kernel: md: bind<sdb>
Apr 11 00:39:40 localhost kernel: md: bind<sdc>
Apr 11 00:39:40 localhost kernel: raid5: automatically using best
checksumming function: generic_sse
Apr 11 00:39:40 localhost kernel:    generic_sse:  4111.000 MB/sec
Apr 11 00:39:40 localhost kernel: raid5: using function: generic_sse
(4111.000 MB/sec)
Apr 11 00:39:40 localhost kernel: md: raid5 personality registered as nr 4
Apr 11 00:39:41 localhost kernel: md0: bitmap file is out of date (0 < 1) --
forcing full recovery
Apr 11 00:39:41 localhost kernel: md0: failed to create bitmap (-12)
Apr 11 00:39:41 localhost kernel: md: pers->run() failed ...
Apr 11 00:39:41 localhost kernel: md: md0 stopped.
Apr 11 00:39:41 localhost kernel: md: unbind<sdc>
Apr 11 00:39:41 localhost kernel: md: export_rdev(sdc)
Apr 11 00:39:41 localhost kernel: md: unbind<sdb>
Apr 11 00:39:41 localhost kernel: md: export_rdev(sdb)
Apr 11 00:39:41 localhost kernel: md: unbind<sda>
Apr 11 00:39:41 localhost kernel: md: export_rdev(sda)

I am not able to get why mdadm is failing.

Please suggest some pointers so that I can solve this problem.

Thanks,
Yogesh Pahilwan

