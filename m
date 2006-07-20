From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Is it possible to recover data after resync?
Date: Wed, 19 Jul 2006 19:27:18 -0700 (PDT)
Message-ID: <20060720022718.36299.qmail@web50213.mail.yahoo.com>
References: <17598.55179.66969.564751@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17598.55179.66969.564751@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



--- Neil Brown <neilb@suse.de> wrote:

> On Wednesday July 19, alex14641@yahoo.com wrote:
> > Situation:
> > 
> > I accidentally killed the power to my 5-disk RAID 5 array. I then powered
> > it back up and rebooted the system. After reboot, however, I got the follow-
> > ing error when trying to assemble the array:
> > 
> > mdadm -A -amd /dev/md0 /dev/sd[a-e]
> > mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
> > 
> > I had read somewhere that it's possible to recover an array using the -C
> > option to mdadm. Unfortunately, I didn't specify 'missing', so instead of
> > recovering, it's resyncing. 
> 
> --assemble --force is worth try first and is much safer.
> 
> > 
> > Is there any way to recover the original data?
> 
> Well, if you got all the right devices in the right order, then your
> data should be fine.  If not, I hope you have good backups, because
> they are your only hope.
> 
> NeilBrown
> 

So do I just keep doing mdadm -A /dev/md0 /dev/.... using different 
permutations of the devices until my data shows up?


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
