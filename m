From: Andrew Hogue <hogue@cs.yorku.ca>
Subject: 15% used but "No space left on Device"
Date: Sun, 16 Nov 2003 13:13:49 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0311161309010.12003@nemesis.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just set up 2 hard disks as a striped raid-0 on my system.  They are
Serial-ATA 250GB each.  I'm using linux kernel 2.4.22 and the ext2
filesystem.

The problem I'm encountering happens after using up about 65GB on the
raid.  If I do any file-io, i.e. cat > anything.txt , it tells me that
there is "no space left on device".

I do a df -h and it says that I'm using only 15% of the raid, and that
there is 370G free.  I do a df -i to check the inode usage and it says
that I'm only using 1% of the inodes.

Any ideas?

Thanks,

-- Andrew

