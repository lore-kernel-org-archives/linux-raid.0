From: Carlos Williams <carloswill@gmail.com>
Subject: Building RAID5 w/o a Hot Spare
Date: Wed, 27 Jan 2010 09:26:50 -0500
Message-ID: <d80f793f1001270626s3ec1791ma0b5da4b87a31e34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am building a Linux system which has 4 identical 'fd' partitions on
each of the 4 drives. I don't want to use the 4th partition or disk if
you would like to call it as a 'hot spare'. I would like to span the
entire array over the 4 drives. My question is does my command look
correct for doing so?

mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/sda2 /dev/sdb2
/dev/sdc2 /dev/sdd2

I shouldn't have to specify any additional flags in the 'mdadm'
command to make sure it uses all 4 drives as the RAID5 array, right?
