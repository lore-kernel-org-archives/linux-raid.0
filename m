From: "Lewis Shobbrook" <lshobbrook@fasttrack.net.au>
Subject: root filesystem copy ro raid
Date: Mon, 17 Feb 2003 16:39:23 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <84BB6E1F4E011742AFB186D469FDEA9A015BD5@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm surprised to find such little info on copying an existing filesystem
onto a new raid partition.  
The howto's use cp -a or pipe to cpio -pm .
I've tried both methods, but here we have the problem of symbolic links
and hardlinks not being copied, which when you have an elaborate system
that you'd like to migrate across to raid, doesn't cut the mustard. 
Has anyone tried or succeeded with any alternate methods?  Are there any
utilities such as parted to copy the whole lot.  
I'm not sure how apps such as parted work, but as /dev/mdX is formatted
with mke2fs, as is most root filesystem, I'd like to hope that with a
raid aware kernel and the root filesystem unmounted it could be copied
directly eg.  /dev/hda1 => /dev/mdX.

Apologies if this topic has been visited before, I couldn't find any
reference to it in the archives...


Lewis

