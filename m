From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Fri, 8 Jul 2005 18:56:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0507081852360.29479-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.58.0507080848470.4766@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0507080848470.4766@chaos.egr.duke.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > >>   md0          /boot      sd[ab]1
> > >>   md1          /          sd[ab]2
> > >>   md2          /usr       sd[ab]3
> > >>   md3          /var       sd[ab]4
...
> There are other reasons to use multiple partitions.  Having /home as a 
> separate partition, e.g., allows one to reinstall without copying the data 
> off to another machine.  It also prevents a user from filling up the root 
> fs, which often has bad consequences.  The same goes for partitions for 
> /tmp and/or /var.

one very serious problem with this approach is that each filesystem
will probably be journaled, which means that it'll spend a lot of time
shuttling the heads between journal and data areas.  if you have activity
on /, /usr and /var at the same time, your heads will do little other 
than rush madly around.  in cases where this can't be avoided (for instance,
using quotas to eliminate the user-fills-partition problem), you can 
often improve things markedly by turning on noatime/nodiratime.

