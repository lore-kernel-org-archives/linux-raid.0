From: Karsten Becker <KB@Karsten-Becker.de>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Thu, 09 May 2002 23:32:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CDAEAE3.9060506@Karsten-Becker.de>
References: <001701c1f79e$50349000$c264a8c0@hoytpub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Artur Jasowicz <arturj@mousebusiness.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Jasowicz wrote:

>I've posted the message below to linux-kernel, but there were no replies. Does anyone here have any suggestions?
>
>I am building a file server with 5 drive software RAID5 array. I am using three IWill SIDE-100 (Highpoint 370A) controllers as my IDE interfaces, not using their RAID functionality. One Maxtor 160GB drive per channel, two channels per controller. I plan on adding hot spare as the sixth drive in the future. There's one 160GB partition on each drive. Linux version 2.4.19-pre7smp-020502b (root@production) (gcc version 2.96 20000731 (Red Hat Linux 7.1 2.96-98)) #6 SMP Thu May 2 12:15:34 CDT 2002
>This is a dual Athlon 2000+ MP on Tyan Tiger S2466N-4 with 1GB RAM. OS and swap runs on separate drives and controllers. This array will be just for data once it is configured.
>
>Below are the most relevant parts of my logs. I will post further details if anyone is willing to help, just let me know what info you need. Any suggestions greatly appreciated.
>
I Had the same problem on my old Server. I found out that gigabyte said, 
this is a 33UDMA-Board but linux tried to run the disk in UDMA66. 
Throtteling down the disks using HDPARM -X was the solution for me.
cheers,
Karsten


