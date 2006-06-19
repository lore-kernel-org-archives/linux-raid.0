From: Paul Davidson <Paul.Davidson@anu.edu.au>
Subject: Re: Is shrinking raid5 possible?
Date: Mon, 19 Jun 2006 15:07:25 +1000
Message-ID: <4496310D.7020109@anu.edu.au>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17558.10906.59066.196870@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Yep.
> The '--size' option refers to:
>               Amount  (in  Kibibytes)  of  space  to  use  from  each drive in
>               RAID1/4/5/6.  This must be a multiple of  the  chunk  size,  and
>               must  leave about 128Kb of space at the end of the drive for the
>               RAID superblock.  
> (from the man page).
> 
> So you were telling md to use the first 600GB of each device in the
> array, and it told you there wasn't that much room.
> If your array has N drives, you need to divide the target array size
> by N-1 to find the target device size.
> So if you have a 5 drive array, then you want
>   --size=157286400
> 
> NeilBrown

Thanks, and sorry for not being able to read properly -- I read this at
least three times and didn't notice it was the drive size and not the
array size.

Cheers, Paul.
