From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: endianness of Linux kernel RAID
Date: Wed, 03 Aug 2005 11:51:48 -0400
Message-ID: <42F0E814.2060403@steeleye.com>
References: <20050803120656.GA16696@anthropohedron.net> <42F0C117.5020506@steeleye.com> <20050803153617.GA31258@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050803153617.GA31258@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Gregory Seidman wrote:

> 1) Does this mean that the fix will be in 2.6.13?

Yes, version 1 superblock support is in 2.6.13. You need the latest 
mdadm as well.

> 2) Does the version 1 you refer to have to do with pre-2.6 RAID support?

No. 2.4 kernels do not understand version 1 superblocks. They only 
support 0.90 superblocks (which is what you've got).

> 3) My existing RAID was original set up under 2.4.18 on PPC, but I'm
>    running 2.6.11 now and it works fine... for now. If metadata was
>    previously stored in host endian, does that mean that my existing RAID
>    that was set up on PPC is going to break, or be upgraded, or what?

You'll have to re-create the array using the version 1 superblock 
format. The existing 0.90 superblocks will continue to be used until 
you've done that.

--
Paul
