From: Sevrin Robstad <quackyo@start.no>
Subject: Re: bad performance on RAID 5
Date: Thu, 18 Jan 2007 21:43:12 +0100
Message-ID: <45AFDBE0.9090507@start.no>
References: <45AE9640.1040500@start.no> <45AFBC85.8020500@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <45AFBC85.8020500@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steve Cousins wrote:
> Sevrin Robstad wrote:
>> I'm suffering from bad performance on my RAID5.
>>
>> a "echo check >/sys/block/md0/md/sync_action"
>>
>> gives a speed at only about 5000K/sec , and HIGH load average :
> What do you get when you try something like:
>
> time dd if=/dev/zero of=/mount-point/test.dat bs=1024k count=1024
>
> where /mount-point is where /dev/md0 is mounted.
>
> This will create a 1 GiB file and it will tell you how long it takes 
> to create it.  Also, I'd try running Bonnie++ on it to see what the 
> different performance values are.
>
> I don't know a lot about the md sync process but I remember having my 
> sync action stuck at a low value at one point and it didn't have 
> anything to do with the performance of the RAID array in general.
>

I ran the a couple of times, and got either about 28MB/s or about 
34MB/s. strange.
When I run the same test on a single disk connected to another 
controller I get about 60MB/s.


[root@compaq ~]# time dd if=/dev/zero of=/mnt/gigaraid/1gb.testfile 
bs=1024k cou   nt=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 38.1873 seconds, 28.1 MB/s

real    0m38.321s
user    0m0.009s
sys     0m8.602s
[root@compaq ~]# time dd if=/dev/zero of=/mnt/gigaraid/1gb.testfile 
bs=1024k cou   nt=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 31.4377 seconds, 34.2 MB/s

real    0m31.949s
user    0m0.016s
sys     0m8.988s
[root@compaq ~]# time dd if=/dev/zero of=/mnt/gigaraid/1gb.testfile 
bs=1024k cou   nt=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 37.599 seconds, 28.6 MB/s

real    0m38.151s
user    0m0.011s
sys     0m9.291s
[root@compaq ~]# time dd if=/dev/zero of=/mnt/gigaraid/1gb.testfile 
bs=1024k count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 31.2569 seconds, 34.4 MB/s

real    0m31.765s
user    0m0.007s
sys     0m8.913s
[root@compaq ~]# time dd if=/dev/zero of=/mnt/gigaraid/1gb.testfile 
bs=1024k count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 37.4778 seconds, 28.7 MB/s

real    0m37.923s
user    0m0.009s
sys     0m9.231s
