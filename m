From: Jools Wills <jools@oxfordinspire.co.uk>
Subject: Re: problem with mdadm --incremental on ubuntu from initramfs
 (path choice related) on version 3.x
Date: Mon, 29 Mar 2010 21:34:50 +0100
Message-ID: <1269894890.26247.40.camel@travelmate.workshop>
References: <1269844303.26247.23.camel@travelmate.workshop>
	 <20100329200130.GA26734@maude.comedia.it>
Reply-To: jools@oxfordinspire.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100329200130.GA26734@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2010-03-29 at 22:01 +0200, Luca Berra wrote:

> i tought ubuntu had /lib/init/rw, being debian based, or is it only the
> mdadm subdire under that one missing? current git should create the
> latter.

must have been the missing subdir underneath I think. I have found an
ubuntu bug now that addresses the missing /var/run/ folder so I guess it
will be fixed in a future release (Ubuntu has an outdated version of
mdadm also - so I have now built my own package of 3.1.2 and fixed up
the missing initramfs folder)

> >My final thought is, that to make this bug report, I had to come and
> >sign up here on this list, and then hope that the mdadm maintainer will
> >read it. The mdadm software really needs a bugtracker, or better
> >instructions on the site as to how to go about reporting issues

> What's wrong about a mailing list?

Well, first of all it isn't immediately obvious where to report bugs at
all.

http://neil.brown.name/blog/mdadm you then need to surf to the "front"
link then to contact, but it is a little vague.

and as for what's wrong with a mailinglist? all the obvious things
tracking bugs, priority, other people locating similar issues to
comment, tracking patches and so on.

Thanks for your response.

Best Regards

Jools

Jools Wills
-- 
IT Consultant
Oxford Inspire - http://www.oxfordinspire.co.uk - be inspired
t: 01235 519446 m: 07966 577498
jools@oxfordinspire.co.uk

