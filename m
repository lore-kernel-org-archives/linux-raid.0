From: Michal Soltys <nozo@ziu.info>
Subject: RAID and filesystem setup / tuning questions regarding specific scenario
Date: Sun, 22 Jul 2007 02:29:01 +0200
Message-ID: <46A2A4CD.7030003@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm making raid 5 consisting of 4 disks, 500 GB each, with one spare 
standby. In future to be expanded with extra disks. Server will be running 
with ups, and with extra machine doing daily rsync backup of the system and 
stuff deemed important. On top of the raid, there will probably be simple 
lvm2 setup - linear with large extents (512 MB or 1 GB). Files will be 
accessed primarily through samba shares, by 10 - 20 people at the same time. 
Server will have 2GB ram (increasing it, if it's necessary, won't be a 
problem), core2 duo cpu, running 64bit linux. Disks are on ICH9R, in ahci mode.

Currently, users have ~200 GB partition, almost filled up, with ca. 700,000 
files - which gives rather small value ~300 KB / file. From what they say, 
it will be more or less the same on the new machine.


The two basic questions - raid parameters and filesystem choice. I'll of 
course make tests, but potential combination of parameters is not so small, 
so I'm looking for starting tips.


Regarding parameters - I've googled / searched this list, and found some
suggestions regarding parameters like chunk_size, nr_requests, read ahead 
setting, etc. Still I have feeling, that suggested settings are rather 
tailored more towards big filesizes - and it's certainly not the case here. 
Wouldn't values - like 64 MB read ahead on whole raid device, 1MB chunks - a 
bit overkill in my scenario ? Maybe someone is running something similar, 
and could provide some insights ?


Regarding filesystem - I've thought about actually using ext3 without the 
journal (so effectively ext2), considering ups and regular backups to 
separate machine. Also, judging from what I've found so far, XFS is not that 
great in case of many small files. As for ext2/3, googling revealed 
documents like http://ext2.sourceforge.net/2005-ols/paper-html/index.html , 
which are quite encouraging (besides, document is already 2 years old). 
Another advantage of ext2/3, is that it can be shrinked, whereas XFS cannot,
afaik.

How much of a performance gain would I get from using journalless ext3 ? 
Either way, is testing ext2/3 worthwhile here, or should I jump right to XFS ?


Misc. more specific questions:

- lvm2

In my scenario - linear, big extents - is there a [significant] performance 
hit coming from using it ? Any other caveats I should be aware of ?

- read ahead

All the elements of the final setup - drives themselves, RAID, LVM2 - have 
read ahead parameter. How should they be set, relatively to each other ? 
Also, basing on  http://www.rhic.bnl.gov/hepix/talks/041019pm/schoen.pdf - 
too big read ahead can hurt performance in multiuser setup. And as mentioned 
above - 64 MB seems a bit crazy... Availabilty of memory is not an issue though.

Any other "stacking" parameters that should be set properly ?

- nr_requests

I've also found suggestion about increasing this parameter - to 256 or 512, 
in http://marc.info/?l=linux-raid&m=118302016516950&w=2 . It was also 
mentioned in some 3ware technical doc. Any comments on that ?

- max_sectors_kb

Any suggestions regarding this one ? I've found suggestions to set it to 
chunk size, but it seems strange (?)

- journal on separate devices

Generaly - how fast should be the extra drive, compared to the RAID array ? 
Also how big ? Any side effects of setting it big (on ext3, there's limit 
when the journal is set on the main partition due to memory requirements; 
but there's no limit when it's on separate drive) ?


