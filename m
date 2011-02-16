From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 23:53:17 +0100
Message-ID: <20110216225317.GA3306@lazy.lzy>
References: <20110216212751.51a294aa@notabene.brown>
 <20110216202939.GA2756@lazy.lzy>
 <20110217084826.77f4dbf1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110217084826.77f4dbf1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > when the rebuild of the secondary completes.  Commonly this would be
> > > ideal, but if the secondary experienced any write errors (that were
> > > recorded in the bad block log) then it would be best to leave both in
> > > place until the sysadmin resolves the situation.   So in the first
> > > implementation this failing should not be automatic.
> > 
> > Maybe putting the primary as "spare", i.e. not failed nor
> > working, unless the "migration" was not successful. In that
> > case the secondary device should be failed.
> 
> Maybe ... but what if both primary and secondary have bad blocks on them?
> What do I do then?

IMHO this means migration was not sucessful, so
you return to the original state, with the
primary disk up and running.

Assuming you realize the secondary has bad blocks,
otherwise I do not think there are any possibilities.
 
> > My use case here is disk "rotation" :-). That is, for example, a
> > RAID-5/6 with n disks + 1 spare. Each X months/weeks/days/hours
> > one disk is pulled out of the array and the spare one takes over.
> > The pulled out disk will be the new spare (and powered down, possibly).
> > The idea here is to have n disks which will have, after some time,
> > different (increasing) power on hours, so to minimize the possibility
> > of multiple failures.
> 
> Interesting idea.  This could be managed with some user-space tool that
> initiates the 'hot-replace' and 'fail' from time to time and keeps track of
> ages.

Exactly, my idea was to have a daemon, which, time to time, maybe
reading the power up hours from the SMART information, will remove
the oldest disk replacing it with the youngest.
There could be other policies, of course.
 
> > > Better reporting of inconsistencies.
> > > ------------------------------------
> > > 
> > > When a 'check' finds a data inconsistency it would be useful if it
> > > was reported.   That would allow a sysadmin to try to understand the
> > > cause and possibly fix it.
> > 
> > Could you, please, consider to add, for RAID-6, the
> > capability to report also which device, potentially,
> > has the problem? Thanks!
> 
> I would rather leave that to user-space.  If I report where the problem is, a
> tool could directly read all the blocks in that stripe and perform any fancy
> calculations you like.  I may even write that tool (but no promises).

I guess you have already the tool, don't you remember? :-)

bye,

-- 

piergiorgio
