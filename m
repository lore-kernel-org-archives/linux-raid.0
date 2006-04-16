From: Neil Brown <neilb@suse.de>
Subject: Re: Questions about: Where to find algorithms for RAID5 / RAID6
Date: Mon, 17 Apr 2006 09:47:49 +1000
Message-ID: <17474.55205.159398.46695@cse.unsw.edu.au>
References: <443B6DF3.2060500@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maurice Hilarius on Tuesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 11, maurice@harddata.com wrote:
> Good day.
> 
> I am looking for some information, and hope the readers of this list
> might be able to point me in the right direction:
> 
> Here is the scenario:
> In RAID5 ( or RAID6) when a file is written, some parity data is
> created, (by some form of XOR process, I assume), then that parity data
> is written to disk.
> 
> I am looking to find the algorithm that is used to create that parity
> data and to decides where to place it on the disks.
> 
> Any help on this is deeply appreciated.
> 

wikipedia has some useful information, and definitely has a link to a
paper that described raid6 on linux.

NeilBrown
