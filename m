From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Software RAID-0 striping over Hardware RAID-5
Date: Wed, 22 Sep 2004 17:23:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41521782.7030908@nsr500.net>
References: <200409201713.i8KHDxj01473@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200409201713.i8KHDxj01473@www.watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



>>From what I have read, RAID0 will just go as fast as your slowest disk.

Almost 2X faster.

[16:52] abit: > cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid0 sdb5[1] sda5[0]
       4192768 blocks 32k chunks

md1 : active raid0 sdb6[1] sda6[0]
       2425600 blocks 32k chunks

md2 : active raid0 sdb7[1] sda7[0]
       12707200 blocks 16k chunks

md3 : active raid0 sdb8[1] sda8[0]
       20113152 blocks 64k chunks

unused devices: <none>

102400+0 records in
102400+0 records out
: 10.72 19% 0:10.72 s 2.12 u 0.02 mapf 112 mipf 12
: dd if=/dev/sda5 of=/dev/null bs=4k count=100k
102400+0 records in
102400+0 records out
: 11.33 19% 0:11.33 s 2.18 u 0.06 mapf 112 mipf 12
: dd if=/dev/sdb5 of=/dev/null bs=4k count=100k
102400+0 records in
102400+0 records out
: 5.81 32% 0:05.81 s 1.81 u 0.07 mapf 112 mipf 12
: dd if=/dev/md0 of=/dev/null bs=4k count=100k

[17:20] abit:~ > echo "scale=2;102400*4*1024;((10.72+11.33)/2)/5.81" | bc -q
419430400
1.89
