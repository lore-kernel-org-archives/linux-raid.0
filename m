From: Neil Brown <neilb@suse.de>
Subject: Re: Why can't I stop these arrays? PATCH
Date: Tue, 24 Jun 2008 08:42:10 +1000
Message-ID: <18528.9922.990608.442776@notabene.brown>
References: <20080622223517.GD5474@nexus.edgeofthenet.org>
	<485ED8F9.70203@gmail.com>
	<20080623004613.GA6189@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Richard Michael on Sunday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 22, rmichael-raid@edgeofthenet.org wrote:
> 
> Since this has come up on the mailing before, is there any interest in
> this trivial one liner?  (Perhaps it needs to go elsewhere in the code
> as well.)
> 
> diff -u -r mdadm-2.6.7/Manage.c mdadm-2.6.7-local/Manage.c
> --- mdadm-2.6.7/Manage.c        2008-06-05 22:11:04.000000000 -0400
> +++ mdadm-2.6.7-local/Manage.c  2008-06-22 20:35:25.000000000 -0400
> @@ -115,6 +115,7 @@
>                         if (quiet==0)
>                                 fprintf(stderr, Name ": fail to stop array %s: %s\n",
>                                         devname, strerror(errno));
> +                               fprintf(stderr, "Perhaps a running process, mounted filesystem or active volume group?\n");
>                         return 1;
>                 }
>                 if (quiet <= 0)
> 

Somewhere way down on my TODO list is
  Improve error messages to try and really explain what is
  going on.

This is in line with that so I'm happy to take it.
However I would at least like the new message to be conditional on
   errno == EBUSY

I don't think any other error are possible, but it is good practice,
provides implicit documentation, and guards against possible future
changes.

NeilBrown
