From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Thu, 21 Nov 2002 11:39:51 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021121193950.GD770@nic1-pc.us.oracle.com>
References: <20021120234743.GF29881@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021120234743.GF29881@marowsky-bree.de>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 21, 2002 at 12:47:43AM +0100, Lars Marowsky-Bree wrote:
> However, for none-RAID devices like multipathing I believe that activating a
> drive on multiple hosts should be possible; ie, for these it might not be
> necessary to scribble to the superblock every time.

	Again, if you don't use persistent superblock and merely run the
mkraid from your initscripts (or initrd), raid0 and multipath work just
fine today.

Joel


-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
