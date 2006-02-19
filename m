From: Jeff Hardy <hardyjm@potsdam.edu>
Subject: Re: component devices too large
Date: Sat, 18 Feb 2006 19:37:15 -0500
Message-ID: <1140309435.2932.53.camel@fritzdesk.potsdam.edu>
References: <1140298102.2932.23.camel@fritzdesk.potsdam.edu>
	 <17399.43521.951471.838911@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17399.43521.951471.838911@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The amount of each component drive this is actually in use is stored -
> in the default metadata - in a 32bit number as kilobytes.
> This sets a limit of 4TB.
> 
> The version-1 metadata format has a 64bit field.
> 
> If you use mdadm 2.3, it will automatically select version-1 metadata
> if you choose a size larger than 2TB (I think).
> You might also need a very recent (16-rc) kernel for v.large raid1 to
> work.  There were bugs related to this usage pattern that were fixed
> only recently.
> 
> To avoid resyncing >4TB, use of a write-intent-bitmap is strongly
> recommended. 

Thanks for the quick reply.  I see now that mdadm supported the new
version-1 metadata format as of 1.8.1, though that was labelled a devel
release in its Announcement (also where the new metadata is mentioned).
I do not see any mention of this in the Changelog however until 2.0,
which allows you to specify the metadata type with the '-e' option.

Also, the man pages for the 2.x releases state that the default metadata
"limits arrays to 28 componenet devices and limits component devices of
levels 1 and greater to 2 terabytes."

So, I admit I am still confused.  Either:

1) As you indicated, and I have seen myself, I can go up to 4TB with the
default metadata on 1.11.0 which means the man pages for 2.x, the first
to actually mention metadata, are incorrect.

2) mdadm-1.11.0 (which I am using), and possibly earlier, supported
version-1 metadata, but it was not a selectable option within mdadm, but
rather mdadm auto-selected metadata based on what options and sizes one
threw at it.

3) Neither of the above, and I was just bloody lucky to be able to
create an array that size, and anything beyond 2TB on mdadm 1.x is not a
very good idea for production use.

:)

Again, thanks for the info, and if you have any further insight, I'd be
grateful.


-- 
Jeff Hardy
Systems Analyst
hardyjm at potsdam dot edu

