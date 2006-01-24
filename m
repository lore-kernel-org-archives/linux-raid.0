From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.2 SEGFAULT: mdadm --assemble --scan
Date: Tue, 24 Jan 2006 17:28:23 +1100
Message-ID: <17365.51463.120411.945898@cse.unsw.edu.au>
References: <20051222205809.GC492@skl-net.de>
	<43B6A0F9.8040100@xss.co.at>
	<43C182D7.5030105@tmr.com>
	<43C50D7C.30106@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas Haumer on Wednesday January 11
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Haumer <andreas@xss.co.at>
Cc: Bill Davidsen <davidsen@tmr.com>, Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 11, andreas@xss.co.at wrote:
> Index: mdadm/Assemble.c
> ===================================================================
> RCS file: /home/cvs/repository/distribution/Utilities/mdadm/Assemble.c,v
> retrieving revision 1.1.1.7
> diff -u -r1.1.1.7 Assemble.c
> - --- mdadm/Assemble.c    5 Dec 2005 05:56:20 -0000    1.1.1.7
> +++ mdadm/Assemble.c    31 Dec 2005 15:01:34 -0000
> @@ -219,7 +219,7 @@
>         }
>         if (dfd >= 0) close(dfd);
> >>
> - -        if (ident->uuid_set && (!update && strcmp(update, "uuid")!=
> 0) &&
> +        if (ident->uuid_set && (update && strcmp(update, "uuid")!= 0) &&
>             (!super || same_uuid(info.uuid, ident->uuid,
> tst->ss->swapuuid)==0)) {
>             if ((inargv && verbose >= 0) || verbose > 0)
>                 fprintf(stderr, Name ": %s has wrong uuid.\n",
> 
> >>
> > Is that right now? Because && evaluates to zero or one left to right,
> > the parens and the "!=0" are not needed, and I assume they're in for a
> > reason (other than to make the code hard to understand). A comment
> > before that if would make the intention clear, I originally though the
> > "(!update" was intended to be "!(update" which would explain the parens,
> > but that seems wrong.
> 
> I made this modification out of the following reasoning:
> 
> It does not make sense to check if update is NULL and
> then use it in a strcmp(). It only makes sense to check
> if update is _not_ NULL and then do the strcmp()
> 
> (a similar code fragment can be found in the same sourcefile
> several lines below)
> 
> This cures the segfault, but I can not really say if the
> whole construct is logically correct (you are right, it
> looks suspicious...)
> That should be answered by Neil ;-)

Sorry it has taken me so long to get back to you on this...

Thanks for reporting the problem.
The correct fix is

diff ./Assemble.c~current~ ./Assemble.c
--- ./Assemble.c~current~	2005-12-05 16:56:20.000000000 +1100
+++ ./Assemble.c	2006-01-24 17:25:20.000000000 +1100
@@ -219,7 +219,7 @@ int Assemble(struct supertype *st, char 
 		}
 		if (dfd >= 0) close(dfd);
 
-		if (ident->uuid_set && (!update && strcmp(update, "uuid")!= 0) &&
+		if (ident->uuid_set && (!update || strcmp(update, "uuid")!= 0) &&
 		    (!super || same_uuid(info.uuid, ident->uuid, tst->ss->swapuuid)==0)) {
 			if ((inargv && verbose >= 0) || verbose > 0)
 				fprintf(stderr, Name ": %s has wrong uuid.\n",


i.e. change the && to and ||.

I guess I'd better do a '2.3'...

Thanks,
NeilBrown
