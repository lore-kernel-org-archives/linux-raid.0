From: =?UTF-8?Q?Gar=C3=B0ar_Arnarsson?= <gardar@giraffi.net>
Subject: Backup file size when migrating from raid5 to raid6?
Date: Sun, 6 May 2012 10:17:52 +0000
Message-ID: <CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My raid5 array has gotten a bit big, it's containing total 10 drives
right now (I started out with 3 drives). So I am going to convert it
to raid6 before it gets any bigger.

I am doing a test-run on a virtual machine with virtual drives to see
that everything works flawlessly.

When I tried to convert the array to raid6 I got a error message about
a missing backup-file

mdadm --grow /dev/md0 --raid-devices=5 --level=6

mdadm level of /dev/md0 changed to raid6
mdadm: /dev/md0: Cannot grow - need backup-file
mdadm: aborting level change

I added the backup file and was able to convert the array successfully
after that.

My question is, how big is this backup file going to be? My real raid
array consists of 2tb drives, will the backup file be as big as one
drive in the array, or will it just be few megabytes or gigabytes?
I'm asking because I'm wondering if I need to buy an extra hdd for the
backup file or if the backup file can just be on my OS hdd that has
around 100gb free.
