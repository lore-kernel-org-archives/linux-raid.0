From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Is it possible to recover data after resync?
Date: Wed, 19 Jul 2006 20:54:11 -0700 (PDT)
Message-ID: <20060720035411.7327.qmail@web50207.mail.yahoo.com>
References: <17598.62721.936579.64693@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17598.62721.936579.64693@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- Neil Brown <neilb@suse.de> wrote:

> On Wednesday July 19, alex14641@yahoo.com wrote:
> > > 
> > > > 
> > > > Is there any way to recover the original data?
> > > 
> > > Well, if you got all the right devices in the right order, then your
> > > data should be fine.  If not, I hope you have good backups, because
> > > they are your only hope.
> > > 
> > > NeilBrown
> > > 
> > 
> > So do I just keep doing mdadm -A /dev/md0 /dev/.... using different 
> > permutations of the devices until my data shows up?
> > 
> 
> Hard to say without precise details.  Maybe it's worth a try, maybe
> not.

Ignore my previous message. Typing 

mdadm -C -amd -l5 -n5 -c128 /dev/md0 /dev/sde /dev/sdd /dev/sdc /dev/sdb missing

seems to have done the trick. I'll do an add of /dev/sda and an fsck and report
my results later.

> NeilBrown
> 


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
