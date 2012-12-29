From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linear raid extend component
Date: Sat, 29 Dec 2012 09:59:49 -0700
Message-ID: <636A166B-80F3-43BA-A375-05FE670A870F@colorremedies.com>
References: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE9AB803-93DD-4A9A-BA97-FD5F323833DE@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Dec 29, 2012, at 4:44 AM, Adam Goryachev <adam@websitemanagers.com.au> wrote:

> I have 3 RAID devices, 2 RAID1 which are then combined into a linear RAID. I've now replaced both drives of one of the RAID1 (from 2 x 1TB TO 2 x 3TB). 
> 
> I now want to grow the raid1 from 1TB to 3TB and then grow the linear to include the extra space. However, my concern is that if this is the first array in the linear I will corrupt the filesystem because there will be a big blank space in the middle.

What file system? I'm not aware of any off hand that tolerate being grown from anything but the end.


Chris Murphy