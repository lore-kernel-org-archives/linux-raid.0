From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Fri, 8 Jul 2005 08:52:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.58.0507080848470.4766@chaos.egr.duke.edu>
References: <200506300210.j5U2Acp04142@www.watkins-home.com>
 <200506301014.11454.eric@pretorious.net> <87r7eex14d.fsf@pumba.bayour.com>
 <200507071149.54019.eric@pretorious.net> <877jg1fp3d.fsf@pumba.bayour.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877jg1fp3d.fsf@pumba.bayour.com>
Sender: linux-raid-owner@vger.kernel.org
To: Turbo Fredriksson <turbo@bayour.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 8 Jul 2005 at 2:40pm, Turbo Fredriksson wrote

> Quoting Eric Pretorious <eric@pretorious.net>:
> 
> > On Monday 04 July 2005 04:27 am, Turbo Fredriksson wrote:
> >>WHY are you putting multiple md's on the same disks? Did you intend to
> >>do something like this?
> >>
> >>   md0          /boot      sd[ab]1
> >>   md1          /          sd[ab]2
> >>   md2          /usr       sd[ab]3
> >>   md3          /var       sd[ab]4
> >>
> >>Just one question (this is the magic :). What do you gain by this? And
> >>why do you do it?
> >
> > I'm just trying to mirror two disks - that's all. Is there a better way?
> 
> The keyword(s) here is _same disk_.
> 
> This is a very complicated way to do it... The idea behind partitioning the
> disk(s) this way (many partition, one partition for 'each important FS') is
> 'to protect the root partition' (or rather 'protect the file systems from
> each others failures'). That is, a crash in the /var FS (or that partition)
> will not interfere against the /usr FS/partition etc...

There are other reasons to use multiple partitions.  Having /home as a 
separate partition, e.g., allows one to reinstall without copying the data 
off to another machine.  It also prevents a user from filling up the root 
fs, which often has bad consequences.  The same goes for partitions for 
/tmp and/or /var.

> Just create ONE partition (plus a swap on each disk, totaling the total amount
> of swap you want/need) and set that up as md0 (mounted as /) and that's it!

But then if a disk dies, the system is still going to crash, b/c half the 
swap is suddenly gone.  If you want the system to not crash if a disk 
dies, then you must mirror swap as well.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
