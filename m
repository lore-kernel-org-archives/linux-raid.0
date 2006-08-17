From: Pavel Machek <pavel@suse.cz>
Subject: Re: [patch] raid1: allow user to force reads from a specific disk
Date: Thu, 17 Aug 2006 15:04:19 +0000
Message-ID: <20060817150419.GC5950@ucw.cz>
References: <200608062018_MC3-1-C74D-B4E9@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200608062018_MC3-1-C74D-B4E9@compuserve.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi!

> Allow user to force raid1 to read all data from a given disk.
> This lets users do integrity checking by comparing results
> from reading different disks.  If at any time the system finds
> it cannot read from the given disk it resets the disk number
> to -1, the default, which means to balance reads.
> 
> Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>

Using /sysfs as an interface... so that two utilities checking disk
integrity will interfere with each other and integrity check will
interfere with normal work. Perhaps ioctl/fcntl and per-fd status is
would be right thing to do?

-- 
Thanks for all the (sleeping) penguins.
