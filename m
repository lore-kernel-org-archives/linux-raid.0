From: "Artur Jasowicz" <arturj@mousebusiness.com>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Thu, 9 May 2002 22:37:37 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002401c1f7d4$181a78c0$050010ac@niunia.org>
References: <001701c1f79e$50349000$c264a8c0@hoytpub.com> <3CDAEAE3.9060506@Karsten-Becker.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Karsten Becker <KB@Karsten-Becker.de>
List-Id: linux-raid.ids

From: Karsten Becker <KB@Karsten-Becker.de>
> Artur Jasowicz wrote:
>
> >I've posted the message below to linux-kernel, but there were no replies.
Does anyone here have any suggestions?
> >
> >I am building a file server with 5 drive software RAID5 array. I am using
three IWill SIDE-100 (Highpoint 370A) controllers as my IDE interfaces, not
using their RAID functionality. One Maxtor 160GB drive per channel, two
channels per controller. I plan on adding hot spare as the sixth drive in
the future. There's one 160GB partition on each drive. Linux version
2.4.19-pre7smp-020502b (root@production) (gcc version 2.96 20000731 (Red Hat
Linux 7.1 2.96-98)) #6 SMP Thu May 2 12:15:34 CDT 2002
> >This is a dual Athlon 2000+ MP on Tyan Tiger S2466N-4 with 1GB RAM. OS
and swap runs on separate drives and controllers. This array will be just
for data once it is configured.
> >
> >Below are the most relevant parts of my logs. I will post further details
if anyone is willing to help, just let me know what info you need. Any
suggestions greatly appreciated.
> >
> I Had the same problem on my old Server. I found out that gigabyte said,
> this is a 33UDMA-Board but linux tried to run the disk in UDMA66.
> Throtteling down the disks using HDPARM -X was the solution for me.
> cheers,
> Karsten

Thanks for the comment. Actually, the card is 100-capable and the drives are
133s, but hdparm indicates that they run at 100. I've tried taking the
drives down to UDMA2 (33M) with hdparm -X66, but same problem occured.
I wonder if that's not the PCI getting killed with too much traffic.
Artur

