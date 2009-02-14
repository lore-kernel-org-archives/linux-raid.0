From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: 'size_limit' attribute
Date: Sat, 14 Feb 2009 14:20:10 +1100
Message-ID: <18838.14442.891790.33471@notabene.brown>
References: <1234549811.26769.7.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Friday February 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

On Friday February 13, dan.j.williams@intel.com wrote:
> Subject: md: 'size_limit' attribute
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Provide a sysfs attribute to allow a raid array to be truncated to an
> arbitrary size.  This functionality is needed to support imsm raid
> arrays where the metadata format expects that the size of some arrays is
> rounded down to the nearest 1MB boundary.

Well it's not April 1st, so I assume you are serious.

It really truncates the array, not the individual drives?
So you could have e.g. a raid0 in which only some of the last stripe
was used?

Can you give me a concrete example of an array where this will make a
required difference?  I just want to be sure I understand.

I guess you couldn't just add an 'array_size' attribute which gave
direct access to mddev->array_size because that gets set when the
array is started, and we want to be able to impose the limit before
starting the array....

How about a semantic where starting the array will only modify
->array_size if it's value is zero of if it would reduce the value.

How might this interact with array resizing?  You add a drive to an
array, reshape it, and then it doesn't get any bigger until the
size_limit is updated?   I guess that could work but it might be
confusing.... though presumably mdadm/mdmon would know to look after
all the details. 


What would you think of renaming the attribute to 'array_size' with
the semantic of "once user-space sets it, the kernel will never change
it" ??

NeilBrown
