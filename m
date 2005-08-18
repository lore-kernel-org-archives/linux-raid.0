From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Thu, 18 Aug 2005 14:56:22 +0400
Message-ID: <43046956.2040402@tls.msk.ru>
References: <1124322731.3810.77.camel@localhost.localdomain> <17156.7305.638579.812295@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17156.7305.638579.812295@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Pallai Roland <dap@mail.index.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Thanks for this.  There are definitely some good ideas here.
> However I think I would like to do it a little bit differently.
> 
> If we want to mirror a single drive in a raid5 array, I would really
> like to do that using the raid1 personality.
> e.g.
>    suspend io
>    remove the drive
>    build a raid1 (with no superblock) using the drive.
>    add that back into the array
>    resume io.
> 
> Then another drive can be added to the raid1 and synced.

This approach does not work if the drive has one or more unreadable
blocks.  An 'initial raid1 resync' can't be completed because it's
impossible to read+copy that sector, but it's pretty much possible
to reconstruct it from other components of raid5.

/mjt
