From: Neil Brown <neilb@suse.de>
Subject: Re: raid 4, and bitmap.
Date: Mon, 6 Feb 2006 10:03:33 +1100
Message-ID: <17382.33861.622843.613018@cse.unsw.edu.au>
References: <04c201c62855$5efda450$9d00a8c0@dcccs>
	<17378.40767.339455.85486@cse.unsw.edu.au>
	<04d701c62857$9eb02e90$9d00a8c0@dcccs>
	<17378.41629.709430.775224@cse.unsw.edu.au>
	<04f401c62859$407f6910$9d00a8c0@dcccs>
	<00b001c62987$290a4320$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Saturday February 4
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 4, djani22@dynamicweb.hu wrote:
> > Ahh, i almost forget!
> > The mdadm is sometimes drop "cannot allocate memory" and next try
> "segfault"
> > when i try -G --bitmap=internal on 2TB arrays!
> > And after segfault, the full raid is stops...
> >
> > Cheers,
> > Janos
> 
> I think i found the bug, its me. :-)
> 
> Today it happens again, and i see, i have misstyped the "internal" word like
> "intarnal".
> The mdadm is accepted that, and try to make the bitmap on NFS again, and
> crashed the raid.
> 
> I think it is neccessary to better test:
> 
> - the bitmap file's fs
> - the filename itself.
> (i mean did not allow the current directory, or the internal and none to be
> a separated option)

That sound's like a good idea... require a filename to contain at
least one '/', and quite possibly test the filesystem type.  bitmaps
are known to have problems on reiserfs and nfs.  They were developed
and tested on ext3 and there is some slightly hairy code in there...

Thanks for the suggestions.

NeilBrown
