From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: grow problem
Date: Fri, 13 May 2005 13:12:58 +1000
Message-ID: <17028.6970.46578.888643@cse.unsw.edu.au>
References: <42812E77.9060503@advocap.org>
	<17025.18070.800000.318669@cse.unsw.edu.au>
	<42820EC8.1020300@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John McMonagle on Wednesday May 11
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 11, johnm@advocap.org wrote:
> 
> Probably unrelated but I'll pass it on just in case it's useful.
> 
> Added to md0 with no problem.
> When added to md1 got a kernel panic.
> Happened to have serial console logging to this is what is says:

Thanks.  I'm pretty sure I know what happened here:

raid1 maintains a concept of the "last_used" drive and it starts
search from there.
The Oops happened in sync_request at:
	disk = conf->last_used;
	/* make sure disk is operational */

	while (conf->mirrors[disk].rdev == NULL ||
	       !conf->mirrors[disk].rdev->in_sync) {
		if (disk <= 0)
			disk = conf->raid_disks;
		disk--;
		if (disk == conf->last_used)
			break;
	}

'rdev' is not NULL, it is 0xFFFF, do dereferencing ->in_sync from
there caused the oops.
last_used must have been '2', but you just reduced the size of the
array to only have 2 devices, so only '0' and '1' are valid.  '2' fell
off the end of the array.

I'll fix it in the next patchset.

Thanks again,
NeilBrown
