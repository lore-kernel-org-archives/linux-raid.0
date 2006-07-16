From: "A. Liemen" <maillist@liemen.net>
Subject: Random Seek on Array as slow as on single disk
Date: Sun, 16 Jul 2006 17:37:47 +0200
Message-ID: <20060716153736.E36C5200967@smtp.funpic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm having random seek performance problems on our Raid 5 and Raid 10 
arrays. The random seek performance of the whole 14 disk array is just 
as slow as a single disk. This has been tested with 4 identical boxes, 
Single Disk, Raid1, Raid5, Raid10 configurations. Raid5 / Raid10 has 
been tested with 14 disks arrays.

System:

Debian 2.6.15-1-amd64-k8-smp dual opteron 275
Controller: Areca ARC 1160 PCI-X 1GB Cache
Disks: 14x WD400YR - 400GB SATA
Raid: Raid5 / Raid 10 - 64k / 128k stripe
Filesystems: XFS, Reiser, ext3
Ram: 16gb
Schedulers: deadline, anti, cfq


Benchmark:

./bonnie++ -uroot -s40000M

1-4 threads, overall random seeks stay the same (~360 seeks / sec)

Sample bonnie Raid10 output can be found under:

http://alexander.liemen.net/bonnie_sample.txt


No matter if I benchmark a single disk, Raid1 2 disks, Raid5/10 14 disks 
, single thread / multiple threads,
random seek performance always stays at ~ 340-360 seeks per second.

I have also observed overall bad random seek performance on an identical 
production box so it's not just bonnie producing strange results.


Can anyone help me on this?


Thank you a lot
Alex
