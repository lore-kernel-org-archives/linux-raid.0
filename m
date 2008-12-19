From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Fri, 19 Dec 2008 10:51:01 -0600
Message-ID: <cccedfc60812190851x446a6046p2578b8de72edc93b@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
	 <18759.678.74091.236787@notabene.brown>
	 <18761.54425.725696.255055@notabene.brown>
	 <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
	 <cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
	 <18761.56537.935250.561921@notabene.brown>
	 <cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
	 <18761.60380.938542.26851@notabene.brown>
	 <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I'll apply and get back to you. My raid rebuilt 3 times today, quite
> possibly because of this.

I'm now running the patch from
a0da84f35b25875870270d16b6eccda4884d61a7 and it still did a complete
rebuild. Was that expected, the first time the device was re-added?

I just rebooted into the new kernel...

(the logs prefixed with nbd0-frank are the result of the follwoing commands:
mdadm --examine --test /dev/nbd0
mdadm --examine-bitmap /dev/nbd0
and eventually
mdadm /dev/md11 --re-add /dev/nbd0
)

Dec 19 10:30:41 turnip nbd0-frank: /dev/nbd0:
Dec 19 10:30:41 turnip nbd0-frank:           Magic : a92b4efc
Dec 19 10:30:41 turnip nbd0-frank:         Version : 1.0
Dec 19 10:30:41 turnip nbd0-frank:     Feature Map : 0x1
Dec 19 10:30:41 turnip nbd0-frank:      Array UUID :
cf24d099:9e174a79:2a2f6797:dcff1420
Dec 19 10:30:41 turnip nbd0-frank:            Name : turnip:11  (local
to host turnip)
Dec 19 10:30:41 turnip nbd0-frank:   Creation Time : Mon Dec 15 07:06:13 2008
Dec 19 10:30:41 turnip nbd0-frank:      Raid Level : raid1
Dec 19 10:30:41 turnip nbd0-frank:    Raid Devices : 2
Dec 19 10:30:41 turnip nbd0-frank:
Dec 19 10:30:41 turnip nbd0-frank:  Avail Dev Size : 160086384 (76.34
GiB 81.96 GB)
Dec 19 10:30:41 turnip nbd0-frank:      Array Size : 156247976 (74.50
GiB 80.00 GB)
Dec 19 10:30:41 turnip nbd0-frank:   Used Dev Size : 156247976 (74.50
GiB 80.00 GB)
Dec 19 10:30:41 turnip nbd0-frank:    Super Offset : 160086512 sectors
Dec 19 10:30:41 turnip nbd0-frank:           State : clean
Dec 19 10:30:41 turnip nbd0-frank:     Device UUID :
01524a75:c309869c:6da972c9:084115c6
Dec 19 10:30:41 turnip nbd0-frank:
Dec 19 10:30:41 turnip nbd0-frank: Internal Bitmap : 2 sectors from superblock
Dec 19 10:30:41 turnip nbd0-frank:       Flags : write-mostly
Dec 19 10:30:41 turnip nbd0-frank:     Update Time : Fri Dec 19 09:46:48 2008
Dec 19 10:30:41 turnip nbd0-frank:        Checksum : 63bfb069 - correct
Dec 19 10:30:41 turnip nbd0-frank:          Events : 5360
Dec 19 10:30:41 turnip nbd0-frank:
Dec 19 10:30:41 turnip nbd0-frank:
Dec 19 10:30:41 turnip nbd0-frank:     Array Slot : 2 (failed, failed, empty, 1)
Dec 19 10:30:41 turnip nbd0-frank:    Array State : _u 2 failed
Dec 19 10:30:41 turnip nbd0-frank:         Filename : /dev/nbd0
Dec 19 10:30:41 turnip nbd0-frank:            Magic : 6d746962
Dec 19 10:30:41 turnip nbd0-frank:          Version : 4
Dec 19 10:30:41 turnip nbd0-frank:             UUID :
cf24d099:9e174a79:2a2f6797:dcff1420
Dec 19 10:30:41 turnip nbd0-frank:           Events : 4462
Dec 19 10:30:41 turnip nbd0-frank:   Events Cleared : 4462
Dec 19 10:30:41 turnip nbd0-frank:            State : OK
Dec 19 10:30:41 turnip nbd0-frank:        Chunksize : 4 MB
Dec 19 10:30:41 turnip nbd0-frank:           Daemon : 5s flush period
Dec 19 10:30:41 turnip nbd0-frank:       Write Mode : Allow write
behind, max 256
Dec 19 10:30:41 turnip nbd0-frank:        Sync Size : 78123988 (74.50
GiB 80.00 GB)
Dec 19 10:30:41 turnip nbd0-frank:           Bitmap : 19074 bits
(chunks), 0 dirty (0.0%)
Dec 19 10:30:41 turnip nbd0-frank: Pre-setting the recovery speed to
5MB/s to avoid saturating network...
Dec 19 10:30:41 turnip nbd0-frank: Adding /dev/nbd0 to /dev/md11....
Dec 19 10:30:41 turnip kernel: md: bind<nbd0>
Dec 19 10:30:41 turnip nbd0-frank: mdadm: re-added /dev/nbd0
Dec 19 10:30:41 turnip kernel: RAID1 conf printout:
Dec 19 10:30:41 turnip kernel:  --- wd:1 rd:2
Dec 19 10:30:41 turnip kernel:  disk 0, wo:1, o:1, dev:nbd0
Dec 19 10:30:41 turnip kernel:  disk 1, wo:0, o:1, dev:sda
Dec 19 10:30:41 turnip kernel: md: recovery of RAID array md11
Dec 19 10:30:41 turnip kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Dec 19 10:30:41 turnip kernel: md: using maximum available idle IO
bandwidth (but not more than 5120 KB/sec) for recovery.
Dec 19 10:30:41 turnip kernel: md: using 128k window, over a total of
78123988 blocks.


-- 
Jon
