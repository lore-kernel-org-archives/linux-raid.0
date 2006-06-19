From: Neil Brown <neilb@suse.de>
Subject: Re: Is shrinking raid5 possible?
Date: Mon, 19 Jun 2006 14:39:54 +1000
Message-ID: <17558.10906.59066.196870@cse.unsw.edu.au>
References: <44960C45.9050407@anu.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Davidson on Monday June 19
Sender: linux-raid-owner@vger.kernel.org
To: Paul Davidson <Paul.Davidson@anu.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 19, Paul.Davidson@anu.edu.au wrote:
> Hi,
> 
> I'd like to shrink the size of a RAID5 array - is this
> possible? My first attempt shrinking 1.4Tb to 600Gb,
> 
> mdadm --grow /dev/md5 --size=629145600
> 
> gives
> 
> mdadm: Cannot set device size/shape for /dev/md5: No space left on device

Yep.
The '--size' option refers to:
              Amount  (in  Kibibytes)  of  space  to  use  from  each drive in
              RAID1/4/5/6.  This must be a multiple of  the  chunk  size,  and
              must  leave about 128Kb of space at the end of the drive for the
              RAID superblock.  
(from the man page).

So you were telling md to use the first 600GB of each device in the
array, and it told you there wasn't that much room.
If your array has N drives, you need to divide the target array size
by N-1 to find the target device size.
So if you have a 5 drive array, then you want
  --size=157286400

NeilBrown
