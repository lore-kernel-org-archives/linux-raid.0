From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mapping of md device blocks to component blocks? (and vice versa)
Date: Tue, 21 Dec 2004 09:24:04 +1100
Message-ID: <16839.20740.219768.963440@cse.unsw.edu.au>
References: <1102689902.3987.60.camel@localhost.localdomain>
	<41C71F49.4040700@mailcan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Leon Woestenberg on Monday December 20
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leonw@mailcan.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 20, leonw@mailcan.com wrote:
> Hello,
> 
> I would like to re-issue my earlier question:
> 
> Given the LBA (bad) block number of a disk drive, or the block number
> of a partition, how can I tell which block on the /dev/mdX device
> corresponds with it?

There is no easy answer.
You need to understand the layout of the array, and do some
arithmetic.

NeilBrown
