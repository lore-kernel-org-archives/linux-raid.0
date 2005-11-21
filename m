From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Tue, 22 Nov 2005 10:21:12 +1100
Message-ID: <17282.22120.327672.720044@cse.unsw.edu.au>
References: <437E2CB6.2030903@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas Haumer on Friday November 18
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Haumer <andreas@xss.co.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 18, andreas@xss.co.at wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi!
> 
> I just upgraded to mdadm-2.1 from mdadm-1.12.0 and noticed
> that the following command (which is even mentioned in the
> manual page) doesn't work anymore:
> 
> root@tolstoi:~ {838} $ mdadm -Ebsc partitions
> mdadm: cannot open partitions: No such file or directory

No.... I guess I should fix the man page, and maybe the code :-(

In mdadm-2 we've added --bitmap= and use '-b' as a short version.
So sometimes -b takes an argument (--bitmap) and sometimes not
(--brief).  So getopt is told that it takes an optional argument.
This explains the observed behaviour.
Possibly this was a mistake....

I would like it to take an argument in contexts where --bitmap was
meaningful (Create, Assemble, Grow) and not where --brief is
meaningful (Examine, Detail).  but I don't know if getopt_long will
allow the 'short_opt' string to be changed half way through
processing...

At the very least, I can print a message if '-b' is being interpreted
as as --brief, but the option argument is present.

-a has the same problem (--add vs --auto).

I'll see what I can do,
Thanks.


> 
> I also noticed that there is now an additional newline between
> the "ARRAY" lines. Is that intentional? IMHO there should only
> by one newline after each line here.
> 

Oh yes.  That blank line gets filled with 'spares=' if there are
any spares, and =devices=' if --verbose.  But I should remove it in
other cases.  Thanks.

NeilBrown
