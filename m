From: Neil Brown <neilb@suse.de>
Subject: Re: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 17:06:42 +1000
Message-ID: <17467.21890.331141.217376@cse.unsw.edu.au>
References: <WM67BE4064A5314b2eB4218F150486C3CD@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yogesh Pahilwan on Tuesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 11, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Folks,
> 
> I am trying to create RAID5 array using mdadm on kernel 2.6.15 as
> 
> # mdadm -Cv /dev/md0 --assume-clean --force --bitmap=/tmp/bitmap.txt -l5 -n4
> /dev/sd{a,b,c,d}
> 
> But when I execute this command getting the following error:
> 
> mdadm: RUN_ARRAY failed: Cannot allocate memory

How big are your devices?

Try setting a larger bitmap chunk size
    --bitmap-chunk=1024
maybe.

NeilBrown
