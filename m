From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Tue, 22 Nov 2005 14:21:34 +0300
Message-ID: <4382FF3E.7070303@tls.msk.ru>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17282.22120.327672.720044@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andreas Haumer <andreas@xss.co.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
[]
> I would like it to take an argument in contexts where --bitmap was
> meaningful (Create, Assemble, Grow) and not where --brief is
> meaningful (Examine, Detail).  but I don't know if getopt_long will
> allow the 'short_opt' string to be changed half way through
> processing...

getopt allows you to change both long and short options set
before every call (provided argv&argc are intact).  But.

Please, pretty please, don't implement the same options with
different meaning.  It's confusing at best.  Assign short options
to frequently-used commands, and leave only long options for the
rest.  I dunno whichever of --brief or --bitmap is more frequent,
I'd say both can be long-only, but since -b already stands for
--brief, don't use it for --bitmap.

> At the very least, I can print a message if '-b' is being interpreted
> as as --brief, but the option argument is present.
> 
> -a has the same problem (--add vs --auto).

And this is also bad.  In my opinion anyway.

/mjt
