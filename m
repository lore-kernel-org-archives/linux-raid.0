From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: promise sx6000 success / raid options
Date: Mon, 28 Oct 2002 15:46:11 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210281543340.30878-100000@uplift.swm.pp.se>
References: <200210280806.g9S86L220650@mailgate.mailbox.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200210280806.g9S86L220650@mailgate.mailbox.co.za>
To: Vlad Milovanovic <vlad@webmail.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Oct 2002, Vlad Milovanovic wrote:

> ext3 will not slow things down noticeably. I also don't know what type
> of disks and how many disks you are using, but 15 MB/s seems very
> slow. You have also not specified what RAID level you are using, so it
> is difficult to say what your performance should be (ballpark figure).

The 15 meg/s is with a 5 120 gig raid0. I get approx the same with a 6 or 
8 disk RAID5 with a 3ware 7500 controller. This is all with hardware raid 
enabled.

I recreated the RAID5 with 8 disks today and used the stride=16 option and 
that didnt seem to change anything when it comes to performance.
 
> But to answer your question, I have found stride option to make a huge
> impact in RAID 5 setups. Also, depending on what kind of system you
> are running, you may want to look into using the -T largefile (or some
> other) option, to let the filesystem reduce (or increase) the number
> of inodes that you have created. You should pay attention to the way

I used the 100000 bytes/inode when I created the system, sounded like a 
nice number.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

