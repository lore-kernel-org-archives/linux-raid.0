From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 005 of 5] md: Final stages of raid5 expand code.
Date: Thu, 19 Jan 2006 11:32:53 +1100
Message-ID: <17358.56885.928063.466619@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<1060117065635.27881@suse.de>
	<20060117095531.GB27262@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sander on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: sander@humilis.net
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Tuesday January 17, sander@humilis.net wrote:
> NeilBrown wrote (ao):
> > +config MD_RAID5_RESHAPE
> 
> Would this also be possible for raid6?


Yes.  The will follow once raid5 is reasonably reliable.  It is
essentially the same change to a different file.
(One day we will merge raid5 and raid6 together into the one module,
but not today).

> > +          This option allows this restiping to be done while the array
>                                      ^^^^^^^^^
>                                      restriping
> > +	  Please to NOT use it on valuable data with good, tested, backups.
>                  ^^                             ^^^^
>                  do                             without

Thanks * 3.

> 
> Thanks a lot for this feature. I'll try to find a spare computer to test
> this on. Thanks!

That would be great!

NeilBrown
