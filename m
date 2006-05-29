From: Neil Brown <neilb@suse.de>
Subject: Re: problems with raid=noautodetect
Date: Mon, 29 May 2006 14:21:09 +1000
Message-ID: <17530.30389.862288.268450@cse.unsw.edu.au>
References: <4471B188.3060400@umit.at>
	<17522.15774.526526.244768@cse.unsw.edu.au>
	<20060526075308.GC8203@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Friday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 26, bluca@comedia.it wrote:
> On Tue, May 23, 2006 at 08:39:26AM +1000, Neil Brown wrote:
> >Presumably you have a 'DEVICE' line in mdadm.conf too?  What is it.
> >My first guess is that it isn't listing /dev/sdd? somehow.
> 
> Neil,
> i am seeing a lot of people that fall in this same error, and i would
> propose a way of avoiding this problem
> 
> 1) make "DEVICE partitions" the default if no device line is specified.

As you note, we think alike on this :-)

> 2) deprecate the "DEVICE" keyword issuing a warning when it is found in
> the configuration file

Not sure I'm so keen on that, at least not in the near term.


> 3) introduce "DEVICEFILTER" or similar keyword with the same meaning at
> the actual "DEVICE" keyboard

If it has the same meaning, why not leave it called 'DEVICE'???

However, there is at least the beginnings of a good idea here.

If we assume there is a list of devices provided by a (possibly
default) 'DEVICE' line, then 

DEVICEFILTER   !pattern1 !pattern2 pattern3 pattern4

could mean that any device in that list which matches pattern 1 or 2
is immediately discarded, and remaining device that matches patterns 3
or 4 are included, and the remainder are discard.

The rule could be that the default is to include any devices that
don't match a !pattern, unless there is a pattern without a '!', in
which case the default is to reject non-accepted patterns.
Is that straight forward enough, or do I need an
  order allow,deny
like apache has?


Thanks for the suggestion.

NeilBrown
