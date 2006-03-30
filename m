From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Re[2]: ANNOUNCE: mdadm 2.4 - A tool for managing Soft RAID under Linux
Date: Thu, 30 Mar 2006 19:27:23 +0400
Message-ID: <416672969.20060330192723@2ka.mipt.ru>
References: <17451.24526.329349.962585@cse.unsw.edu.au>
 <442BA69B.3020904@bppiac.hu>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442BA69B.3020904@bppiac.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Farkas,

FL> that's realy a long avaiting feature. but at the same time wouldn't it
FL> be finally possible to convert a non raid partition to an raid1? it's
FL> avery common thing and they used to said it's even working on windows:-(
That would be cooler than making a metadevice and copying tons of
files :)

However, AFAIK this would require some support on FS side as well?
FS-addressable space in a RAID metadevice (i.e. submirror) is aligned
till the pre-last 64K block. If the partition was used up completely,
the last [64..128]Kb can be used by its data and need to be remapped
to a free location. And this is quite FS-dependant (like grow/shrink)
and should be addressed by those FS toolkits.

tune2fs and e2fsck do some similar remapping job when we enable/disable
spare superblocks on a used filesystem...

-- 
Best regards,
 Jim Klimov                            mailto:klimov@2ka.mipt.ru

