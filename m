From: Sachin Garg <sgarg.bugreporter@gmail.com>
Subject: Identify actual drives/partitions behind RAID
Date: Mon, 14 Jul 2014 21:55:31 -0400
Message-ID: <CAHCQOsCarp3nnCyKWGpy=_Xn=NnX_qcn8tSumpNJAc5=q9Weqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I want to be able to identify the exact device creating truble for my
RAID-5 backed LVM.

The issue:

I have a 4 disc RAID-5 array that holds my /home asan LVM volume
group. Recently, I am getting errors like:

Buffer I/O error on device dm-7, logical block 10526729

So, I do:

# dmsetup table /dev/dm-7
0 251658240 linear 9:127 2048

Major 9, Minor 127 is my MD device "/dev/md127"

My /dev/md127 is made up of 4 disk partitions.

I want to know on what disk does "logical block 10526729" lie so that
I can identify the culprit and replace that disk.

Any ideas?
Best,
Sachin
