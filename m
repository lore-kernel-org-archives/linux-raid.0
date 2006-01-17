From: Sander <sander@humilis.net>
Subject: Re: [PATCH 005 of 5] md: Final stages of raid5 expand code.
Date: Tue, 17 Jan 2006 10:55:31 +0100
Message-ID: <20060117095531.GB27262@localhost.localdomain>
References: <20060117174531.27739.patches@notabene> <1060117065635.27881@suse.de>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060117065635.27881@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

NeilBrown wrote (ao):
> +config MD_RAID5_RESHAPE

Would this also be possible for raid6?

> +	bool "Support adding drives to a raid-5 array (highly experimental)"
> +	depends on MD_RAID5 && EXPERIMENTAL
> +	---help---
> +	  A RAID-5 set can be expanded by adding extra drives. This
> +	  requires "restriping" the array which means (almost) every
> +	  block must be written to a different place.
> +
> +          This option allows this restiping to be done while the array
                                     ^^^^^^^^^
                                     restriping

> +	  is online.  However it is VERY EARLY EXPERIMENTAL code.
> +	  In particular, if anything goes wrong while the restriping
> +	  is happening, such as a power failure or a crash, all the
> +	  data on the array will be LOST beyond any reasonable hope
> +	  of recovery.
> +
> +	  This option is provided for experimentation and testing.
> +	  Please to NOT use it on valuable data with good, tested, backups.
                 ^^                             ^^^^
                 do                             without

Thanks a lot for this feature. I'll try to find a spare computer to test
this on. Thanks!

	Kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
