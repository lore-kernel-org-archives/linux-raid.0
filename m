From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linear raid extend component
Date: Sat, 29 Dec 2012 11:14:02 -0700
Message-ID: <E2F855BB-D735-4186-8A0A-92DB8024A5DE@colorremedies.com>
References: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Dec 29, 2012, at 4:44 AM, Adam Goryachev <adam@websitemanagers.com.au> wrote:

> 
> Then when complete:
> mdadm --grow /dev/md3 --size=max

In a VM I'm unable to get a linear device to grow. I think you can only grow linear by adding devices. You could partition the 3TB such that the 1st partition matches the total sectors of the partition on the replaced 1TB drive; then add the 2TB partition of the 3TB drive onto the end of the linear array. It'd work, but it's a weird configuration. You're better off reverting to the original setup, and adding the 3TB drives at the end, then growing the file system.

[root@f18v ~]# mdadm -G /dev/md0 --size=max
mdadm: component size of /dev/md0 unchanged at 0K

Chris Murphy