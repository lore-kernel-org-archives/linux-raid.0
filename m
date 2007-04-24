From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 10:46:47 +0100
Message-ID: <462DD207.80000@dgreaves.com>
References: <16046.1177356707@mdt.dhcp.pit.laurelnetworks.com> <462DCFE6.4050708@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <462DCFE6.4050708@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

David Greaves wrote:

> currently recompiling the kernel to allow autorun...

Which of course won't work because I'm on 1.2 superblocks:
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sdb1
md: sdb1 has invalid sb, not importing!
md: invalid raid superblock magic on sdc1
md: sdc1 has invalid sb, not importing!
md: invalid raid superblock magic on sdd1
md: sdd1 has invalid sb, not importing!
md: invalid raid superblock magic on sde1
md: sde1 has invalid sb, not importing!
md: invalid raid superblock magic on sdf1
md: sdf1 has invalid sb, not importing!
md: autorun ...
md: ... autorun DONE.


David

PS Dropped Mike from cc since I doubt he's too interested :)
