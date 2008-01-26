From: "Edward Hourigan" <ehourigan@gmail.com>
Subject: question about mdadm
Date: Fri, 25 Jan 2008 23:46:01 -0500
Message-ID: <4cfdde050801252046j57617db3s1619a6f4d3d9e8f0@mail.gmail.com>
References: <4cfdde050801252038o3cd7ffddkd425dac6cf82099d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4cfdde050801252038o3cd7ffddkd425dac6cf82099d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have a quick question:
I have a 3 disk RAID5 array using mdadm
I wanted to add 2 new disks, so I ran
mdadm --add /dev/md0 /dev/sdd
mdadm --add /dev/md0 /dev/sde
mdadm --grow --raid-devices=5

I forgot about the partitions, sdd1 and sde1, I'm wondering if this is
going to be a problem, or if sdd and sde will work?
It is currently reshaping the array.  Please advise if possible.
A response would be much appreciated!
Thanks,
Ed Hourigan
