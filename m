From: Steven Ihde <sihde@cs.stanford.edu>
Subject: Re: error during raid config
Date: Fri, 16 Jan 2004 10:26:07 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040116182607.GA31026@hamachi.dyndns.org>
References: <011620041818.1453.804@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <011620041818.1453.804@comcast.net>
To: gannan10@comcast.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 16, 2004 at 06:18:07PM +0000, gannan10@comcast.net wrote:
> Hello,
> 
> I get the following error when I tried to setup my raid:
> 
> # mkraid /dev/md0
> handling MD device /dev/md0
> analyzing super-block
> disk 0: /dev/hda1, 489951kB, raid superblock at 489856kB
> /dev/hda1 is mounted
> mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

I use mdadm, not mkraid, but it appears the problem is right there:
"/dev/hda1 is mounted".  Probably if you have a mounted filesystem on
/dev/hda1, you cannot add it to the raid array.  Once you've created
the raid array you can mount /dev/md0 instead of /dev/hda1.

-Steve



