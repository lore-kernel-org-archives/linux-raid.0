From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: Weird blocks at fsync() calls using md
Date: Fri, 28 Jul 2006 15:38:11 +0200
Message-ID: <20060728133811.GB2241@freshdot.net>
References: <20060728101645.GA32686@freshdot.net> <17609.61671.113267.692986@cse.unsw.edu.au> <20060728114704.GA2241@freshdot.net> <17609.65110.567036.457706@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17609.65110.567036.457706@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Neil Brown (neilb@suse.de):

> > 13:28:07.011717 fsync(4)                = 0
> > 13:28:12.748252 open("js_gen.pl", O_WRONLY|O_CREAT|O_TRUNC, 0770) = 3
> > 13:28:12.748427 write(3, "#!/usr/bin/perl -w\nuse strict;\nu"..., 2189) = 2189
> > 13:28:12.748506 fsync(3)                = 0
> > 13:28:13.006702 close(3)                = 0
> Yes, it's weird.  The sync of the .swp file takes a lot longer than
> the fsync of the actual file you are saving....

Yup. And it's always the fsync() on the .swp file too ;)

> I have this theory that there might be some odd interaction between md
> and the drive scheduler.

Well, i never really understood the big difference between the three
models. I used to do deadline on servers, but that turned out to be
REALLY bad (at least on our intranet server). Caused major load on
writes, made NFS b0rk, and when i switched it back to Anticipatory it
was all normal again, so that's what i used afterwards.

Using CFQ gives the same, maybe even worse results.
As does Deadline :S

Strange huh! Only this time the fsync() wasn't on the .swp file but on
the "real" file after writing it's contents...

Kind regards,
Sander.
-- 
| He broke into song because he couldn't find the key. 
| 1024D/08CEC94D - 34B3 3314 B146 E13C 70C8  9BDB D463 7E41 08CE C94D
