From: Neil Brown <neilb@suse.de>
Subject: Re: list of devices that belong to an array
Date: Sat, 23 Dec 2006 10:17:54 +1100
Message-ID: <17804.26530.749879.290208@cse.unsw.edu.au>
References: <5C1FD43E5F1B824E83985A74F396286E03EA2B03@bby1exm08.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Don Hiatt on Friday December 22
Sender: linux-raid-owner@vger.kernel.org
To: Don Hiatt <Don_Hiatt@pmc-sierra.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 22, Don_Hiatt@pmc-sierra.com wrote:
> First off, Merry Christmas everyone! :)

And to you.

> 
> Secondly, given a device that is part of an array, is there a way to figure out
> all the other components if you are using the 1.2 superblock?

uuid=`mdadm -Eb $DEV | sed -ne 's/.* \(UUID=[^ ]*\).*/\1/p'`
mdadm -Esv | grep -B1 $uuid | grep devices=

> 
> With SB=0.90, you could issue a "--examine"  and it would report all the other
> devices (in the following example, that would be /dev/sata[1-4]). However, with
> SB=1.2 (included below) you aren't so lucky. :)

The information you get with 0.90 is the names the devices had last
time the array was assembled, which might still be correct, or might
not.  Unreliable information can be worse than no information.

NeilBrown
