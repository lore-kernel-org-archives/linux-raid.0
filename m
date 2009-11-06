From: Thomas Arthur Oehser <tom@toms.net>
Subject: -G to smaller doesn't move superblock... is there _any_ way to
	shrink?
Date: Fri, 6 Nov 2009 07:53:34 -0500
Message-ID: <20091106125334.GC6212@Toms.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


So, I thought the logical sequence was:

	resize2fs <smaller>
	mdadm -G -z <smaller>
	fdisk <smaller>

... but ...

the mdadm -G -z <smaller> seems to leave the superblock at the end of the partition...

Is there _any_ way to do what I'm trying to do?  I don't see options to tell it I want
the superblock to be at offset X or that the partition is "going to be" smaller... and
I don't see options for switching the superblock format and moving stuff around... and
I'm really not wanting to do --create and cross my fingers that everything "just works".

-Tom

-- 
"Let us do our duty in our shop or our kitchen, the market, the street, the
office, the school, the home, just as faithfully as if we stood in the front
rank of some great battle, and we knew that victory for mankind depended upon
our bravery, strength, and skill.  When we do that the humblest of us will be
serving in that great army which achieves the welfare of the world."
 --Theodore Parker
