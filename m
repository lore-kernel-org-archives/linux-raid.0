From: Danilo Godec <danci@agenda.si>
Subject: Re: mdadm --monitor
Date: Fri, 17 May 2002 08:43:15 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205170842220.22765-100000@duplo.agenda.si>
References: <15587.34271.342444.898591@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15587.34271.342444.898591@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 May 2002, Neil Brown wrote:

> > [root]# cat /usr/local/sbin/raidalert:
> >
> > #!/bin/bash
> > #
> > #
> >
> > logger -p kern.crit -t RAID
> >
>
>
> Try
>    logger -p kern.crit -t RAID $*
>
> the program doesn't get anything on stdin.  I just gets 2 or three
> command-line arguments.

Oh, I see! Yes, this way it does work... :)

Maybe you should explain this explicitly or even add the above example to
the docs.

  D.


