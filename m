From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] raid1: allow user to force reads from a specific disk
Date: Mon, 7 Aug 2006 10:38:36 +1000
Message-ID: <17622.35724.43741.529875@cse.unsw.edu.au>
References: <200608062018_MC3-1-C74D-B4E9@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chuck Ebbert on Sunday August 6
Sender: linux-raid-owner@vger.kernel.org
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday August 6, 76306.1226@compuserve.com wrote:
> Allow user to force raid1 to read all data from a given disk.
> This lets users do integrity checking by comparing results
> from reading different disks.  If at any time the system finds
> it cannot read from the given disk it resets the disk number
> to -1, the default, which means to balance reads.

Could say a little bit more about why you want this?

You could get nearly the same situation be setting the other drives to
write-mostly. 

And the more thorough integrity check is available via
   echo check > /sys/block/mdX/md/sync_action

NeilBrown
