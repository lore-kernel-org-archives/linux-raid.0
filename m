From: Iustin Pop <iusty@k1024.org>
Subject: Re: Same UUID for every member of all array ?
Date: Fri, 13 Apr 2007 09:32:28 +0200
Message-ID: <20070413073228.GA15415@teal.hq.k1024.org>
References: <1176382677.14496.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1176382677.14496.17.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Brice Figureau <brice+lklm@daysofwonder.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 12, 2007 at 02:57:57PM +0200, Brice Figureau wrote:
> Now, I don't know why all the UUID are equals (my other machines are not
> affected).
I think at some point either in sarge or in testing between sarge and
etch, there was included a version of mdadm which had this bug (all
arrays had the same uuid). Yeah, it bit me too a little :)

> Is there a possibility to "hot" change the UUID of each array (and
> change the corresponding superblocks of each member) so that my next
> boot will work ?
did you read the manpage for mdadm (the version in etch)? It has a -U
argument to assemble which does what you want.

regards,
iustin
