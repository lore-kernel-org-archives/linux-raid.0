From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Re: mdadm usage: creating arrays with helpful names?
Date: Thu, 28 Jun 2007 09:37:17 -0400
Message-ID: <20070628133717.GA31927@server>
References: <20070626235402.GA27852@server> <46821682.6050602@dgreaves.com> <20070627235739.GA30527@server> <46836D88.9010708@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46836D88.9010708@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Richard Michael <rmichael-raid@edgeofthenet.org>, Neil Brown <neilb@suse.de>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jun 28, 2007 at 09:12:56AM +0100, David Greaves wrote:
> (back on list for google's benefit ;) and because there are some good 
> questions and I don't know all the answers... )

Thanks, I didn't realize I didn't 'reply-all' to stay on the list.

> Hopefully it will snowball as people who use it then contribute back
> <hint> ;)

I will, I'm also keeping notes and changes to the man page. :)

> --auto md

Ah. Thanks for the example(s).

> >Also, when I use "--create /dev/nicename --auto=p1" (for example), I
> >also see /dev/md_d126 created.  Why?  There is then a /sys/block/md_d126
> >entry (presumably created by the md driver), but no /sys/block/nicename
> >entry.  Why?
> Not sure who creates this, mdadm or udev

I'm guessing the kernel's md driver creates it; neither mdmadm nor udev
(just as the kernel creates, for example, sd* disk entries in /sys, but
udev creates the nice entries in /dev).

> The code isn't that hard to read and you sound like you'd follow it if
> you fancied a skim-read...

I read it for the --create option to see who created /dev/mdXX. :) I'll
take another look.

Thanks David.

Cheers.
