From: Neil Brown <neilb@suse.de>
Subject: Re: Unable to add write-intent bitmap
Date: Sun, 23 Apr 2006 12:39:02 +1000
Message-ID: <17482.59590.954386.580590@cse.unsw.edu.au>
References: <1145743788.10042.33.camel@profit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arthur Britto on Saturday April 22
Sender: linux-raid-owner@vger.kernel.org
To: Arthur Britto <ahbritto@iat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 22, ahbritto@iat.com wrote:
> Hi,
> 
> I am unable to add a write-intent bitmap to an existing array.  The man
> page indicates:
> 
> >When using an internal bitmap, the chunksize is automatically
> >determined to make best use of available space.
> 
> Yet, it appears that bitmap being created is too large and goes past the
> end of the partitions provided to the array.
> 
> How can I add a write-intent bitmap to this array or will I need to
> re-create this array?

You don't need to recreate the array.
There seems to be some confusion in mdadm as to whether sizes are in
'sectors' or 'kibibytes' - I thought I had sorted all that out, but it
seems not.

You should be able to make it work by setting the chunk size
explicitly to 1024k i.e
     mdadm -Gb internal --bitmap-chunk=1024 /dev/md0

Meanwhile I try to sort out the code, make it consistent, and get a
new mdadm out.

Thanks for the report.

NeilBrown
