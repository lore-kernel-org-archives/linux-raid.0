From: linuxmania.lizhi@gmail.com
Subject: Where is MD Device Layer
Date: Thu, 13 Jul 2006 16:31:41 +0800
Message-ID: <23623672.1152779501896.JavaMail.websites@opensubscriber>
Reply-To: linuxmania.lizhi@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I'm new to MD RAID. When I read the book "Understanding the Linux Kernel", I know that there are several layers between Filesystems (e.g. ext2) and block device files (e.g. /dev/sda1). These layers are:
Filesystem <==> Generic Block Layer <==> I/O Scheduler Layer <==> Block Device Driver <==> Block Device.
May I know where exactly is the MD RAID Device Layer(e.g. /dev/md0)?
Thanks a lot!

Linuxmania

--
This message was sent on behalf of linuxmania.lizhi@gmail.com at openSubscriber.com
http://www.opensubscriber.com/messages/linux-raid@vger.kernel.org/topic.html
