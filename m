From: danci@agenda.si
Subject: Re: mdadm --monitor
Date: Thu, 13 Feb 2003 15:22:13 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302131448010.28445-100000@duplo.agenda.si>
References: <15947.24824.849512.207243@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15947.24824.849512.207243@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Feb 2003, Neil Brown wrote:

> On Wednesday January 29, danci@agenda.si wrote:
> > #!/bin/bash
> > /usr/bin/logger -p user.crit -t raidalert $@
> >
> > So I guess I'm all set. I try 'mdadm --fail /dev/md0 /dev/hdg1' and wait.
> > On the console, where 'mdadm --monitor' is running, I get this:
>
> Try adding "--scan" to the "mdadm --monitor" command.
> I can see this is not intuitive - I'll try to tidy up for mdadm-1.1

Nice, this works now.

 Thanks, D.


