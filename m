From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: Re: endianness of Linux kernel RAID
Date: Wed, 3 Aug 2005 11:36:17 -0400
Message-ID: <20050803153617.GA31258@anthropohedron.net>
References: <20050803120656.GA16696@anthropohedron.net> <42F0C117.5020506@steeleye.com>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42F0C117.5020506@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 03, 2005 at 09:05:27AM -0400, Paul Clements wrote:
} Gregory Seidman wrote:
} >It turns out that if one uses the kernel (2.4.x-2.6.x) RAID support (RAID5,
} >anyway, since that's all I've tested), the RAID'd disks cannot be moved to
} >another system with a different endianness. I don't know how hard that
} 
} >Unfortunately, I haven't gotten into kernel development and, therefore, do
} >not have the necessary expertise to fix it. Is anyone here interested in
} >this issue?
} 
} Version 1 superblock support, which was recently added to the 2.6 kernel 
} and mdadm tool, fixes this issue. Metadata is always stored in little 
} endian on disk.

Great! A few questions:

1) Does this mean that the fix will be in 2.6.13?
2) Does the version 1 you refer to have to do with pre-2.6 RAID support?
3) My existing RAID was original set up under 2.4.18 on PPC, but I'm
   running 2.6.11 now and it works fine... for now. If metadata was
   previously stored in host endian, does that mean that my existing RAID
   that was set up on PPC is going to break, or be upgraded, or what?

} Paul
--Greg

