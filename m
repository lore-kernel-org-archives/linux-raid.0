From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: endianness of Linux kernel RAID
Date: Wed, 03 Aug 2005 09:05:27 -0400
Message-ID: <42F0C117.5020506@steeleye.com>
References: <20050803120656.GA16696@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050803120656.GA16696@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Gregory Seidman wrote:
> It turns out that if one uses the kernel (2.4.x-2.6.x) RAID support (RAID5,
> anyway, since that's all I've tested), the RAID'd disks cannot be moved to
> another system with a different endianness. I don't know how hard that

> Unfortunately, I haven't gotten into kernel development and, therefore, do
> not have the necessary expertise to fix it. Is anyone here interested in
> this issue?

Version 1 superblock support, which was recently added to the 2.6 kernel 
and mdadm tool, fixes this issue. Metadata is always stored in little 
endian on disk.

--
Paul
