From: Neil Brown <neilb@suse.de>
Subject: Re: Where is MD Device Layer
Date: Tue, 18 Jul 2006 12:24:57 +1000
Message-ID: <17596.18041.733000.171362@cse.unsw.edu.au>
References: <23623672.1152779501896.JavaMail.websites@opensubscriber>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linuxmania.lizhi@gmail.com on Thursday July 13
Sender: linux-raid-owner@vger.kernel.org
To: linuxmania.lizhi@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 13, linuxmania.lizhi@gmail.com wrote:
> Hi all,
> I'm new to MD RAID. When I read the book "Understanding the Linux Kernel", I know that there are several layers between Filesystems (e.g. ext2) and block device files (e.g. /dev/sda1). These layers are:
> Filesystem <==> Generic Block Layer <==> I/O Scheduler Layer <==> Block Device Driver <==> Block Device.
> May I know where exactly is the MD RAID Device Layer(e.g. /dev/md0)?
> Thanks a lot!

MD lies between "Generic Block Layer" and "I/O Scheduler Layer".

NeilBrown
