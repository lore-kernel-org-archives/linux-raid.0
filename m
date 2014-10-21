From: Hans Kraus <hans@hanswkraus.com>
Subject: Problem with a dgaded array (not related to my last question)
Date: Tue, 21 Oct 2014 22:22:20 +0200
Message-ID: <5446C07C.6060900@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

At first: thanks Neil for your answer about tbe bitmap question.

I have another problem: I tried to rebuild an array, raid 6,
with two drives missing of five. Adding a fourth drive worked
well. But not adding a fith drive. I got following messages:
----------------------------------------------------------------
root@nashorn:/home/kraush/work/mdadm# ./mdadm --stop /dev/md126
mdadm: stopped /dev/md126
root@nashorn:/home/kraush/work/mdadm# ./mdadm --assemble --update=bbl 
/dev/md126
mdadm: /dev/md126 has been started with 4 drives (out of 5).
root@nashorn:/home/kraush/work/mdadm# mdadm --add /dev/md126 /dev/sdj1
mdadm: add new device failed for /dev/sdj1 as 7: Invalid argument
root@nashorn:/home/kraush/work/mdadm# ./mdadm --stop /dev/md126
mdadm: stopped /dev/md126
root@nashorn:/home/kraush/work/mdadm# ./mdadm --assemble --update=bbl 
/dev/md126
mdadm: superblock on /dev/sdj1 doesn't match others - assembly aborted
root@nashorn:/home/kraush/work/mdadm# ./mdadm --assemble --update=bbl 
/dev/md126
mdadm: superblock on /dev/sdj1 doesn't match others - assembly aborted
root@nashorn:/home/kraush/work/mdadm# ./mdadm --assemble  /dev/md126
mdadm: superblock on /dev/sdj1 doesn't match others - assembly aborted
root@nashorn:/home/kraush/work/mdadm# ./mdadm --detail /dev/sdh4
mdadm: /dev/sdh4 does not appear to be an md device
root@nashorn:/home/kraush/work/mdadm# mdadm --assemble  /dev/md126
mdadm: superblock on /dev/sdj1 doesn't match others - assembly aborted
----------------------------------------------------------------
How do I get my array back up and the fith drive added? The size of the
drive partition sdj1 should be sufficient for the array.

Thanks in advance, Hans

PS: I do know the names of the other partitions in the array but not
their position.
