From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Thu, 24 Nov 2005 16:15:33 +1100
Message-ID: <17285.19573.383920.766009@cse.unsw.edu.au>
References: <437E2CB6.2030903@xss.co.at>
	<17282.22120.327672.720044@cse.unsw.edu.au>
	<4382FF3E.7070303@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Tuesday November 22
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andreas Haumer <andreas@xss.co.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 22, mjt@tls.msk.ru wrote:
> Neil Brown wrote:
> []
> > I would like it to take an argument in contexts where --bitmap was
> > meaningful (Create, Assemble, Grow) and not where --brief is
> > meaningful (Examine, Detail).  but I don't know if getopt_long will
> > allow the 'short_opt' string to be changed half way through
> > processing...
> 
> getopt allows you to change both long and short options set
> before every call (provided argv&argc are intact).  But.
> 
> Please, pretty please, don't implement the same options with
> different meaning.  It's confusing at best.  Assign short options
> to frequently-used commands, and leave only long options for the
> rest.  I dunno whichever of --brief or --bitmap is more frequent,
> I'd say both can be long-only, but since -b already stands for
> --brief, don't use it for --bitmap.
> 
> > At the very least, I can print a message if '-b' is being interpreted
> > as as --brief, but the option argument is present.
> > 
> > -a has the same problem (--add vs --auto).
> 
> And this is also bad.  In my opinion anyway.

I'm afraid it is a bit late...
 -f == --force or --fail or  --daemonise (think 'fork')
 -m == --super-minor --mail
 -p == --parity or --program
 -c == --config or --chunk

Think of mdadm as a number of separate program (A, B, C, D, E, G :-)
Each has an independent, though sometimes overlapping, set of options.

It looks like I can get getopt_long to work quite nicely to e.g. '-b'
taking an arg in some contexts, and not in others. so expect that to
be fixed in 2.2.

NeilBrown
