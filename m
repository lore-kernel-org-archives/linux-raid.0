From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Appending to Linear RAID
Date: Fri, 28 May 2004 15:30:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16566.52839.357970.707963@cse.unsw.edu.au>
References: <8E4E38BF6D087F4488E80ABAACA2F3F484D8FD@il27exm02.cig.mot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Novak David-DNOVAK1 on Thursday May 27
To: Novak David-DNOVAK1 <David.Novak@motorola.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 27, David.Novak@motorola.com wrote:
> I just slapped a couple drives together into a linear raid array, but I 
> might want to add more in the future.  Is there a way to add addition disks
> to a linear raid array?  I was thinking that just updating /etc/raidtab
> would do the job, but was wondering if anybody's done it or if there's a 
> good howto I could be pointed to.  Thanks!

Currently the only way to do this is to re-create the array with extra
drives.  This should work without trouble.

It is entirely possible that in a future 2.6 kernel, you will be able
to use:

   mdadm --grow /dev/md0 --add /dev/sdd

or something like that to grow a linear array.
But not yet.

NeilBrown
