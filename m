From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:48:26 +1100
Message-ID: <20110217084826.77f4dbf1@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<20110216202939.GA2756@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216202939.GA2756@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 21:29:39 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> > I all,
> >  I wrote this today and posted it at
> > http://neil.brown.name/blog/20110216044002
> > 
> > I thought it might be worth posting it here too...
> [...] 
> > So the following is a detailed road-map for md raid for the coming
> > months.
> 
> Question, is this for information purpose or are we
> called to a "brainstorming"?

Primarily for information, but I'm always happy to hear other peoples ideas.
Some of them help...
Or maybe it was really a task list for all of you budding programmers out
there ...  I can always hope!.

> 
> [...]
> > Hot Replace
> > -----------
> > 
> > "Hot replace" is my name for the process of replacing one device in an
> > array by another one without first failing the one device.  Thus there
> 
> Didn't we named it also "proactive replacement"? :-)

Probably - but too many syllables, so I cannot remember that so well.

> 
> > It is not clear whether the primary should be automatically failed
> > when the rebuild of the secondary completes.  Commonly this would be
> > ideal, but if the secondary experienced any write errors (that were
> > recorded in the bad block log) then it would be best to leave both in
> > place until the sysadmin resolves the situation.   So in the first
> > implementation this failing should not be automatic.
> 
> Maybe putting the primary as "spare", i.e. not failed nor
> working, unless the "migration" was not successful. In that
> case the secondary device should be failed.

Maybe ... but what if both primary and secondary have bad blocks on them?
What do I do then?

> 
> My use case here is disk "rotation" :-). That is, for example, a
> RAID-5/6 with n disks + 1 spare. Each X months/weeks/days/hours
> one disk is pulled out of the array and the spare one takes over.
> The pulled out disk will be the new spare (and powered down, possibly).
> The idea here is to have n disks which will have, after some time,
> different (increasing) power on hours, so to minimize the possibility
> of multiple failures.

Interesting idea.  This could be managed with some user-space tool that
initiates the 'hot-replace' and 'fail' from time to time and keeps track of
ages.


> 
> > Better reporting of inconsistencies.
> > ------------------------------------
> > 
> > When a 'check' finds a data inconsistency it would be useful if it
> > was reported.   That would allow a sysadmin to try to understand the
> > cause and possibly fix it.
> 
> Could you, please, consider to add, for RAID-6, the
> capability to report also which device, potentially,
> has the problem? Thanks!

I would rather leave that to user-space.  If I report where the problem is, a
tool could directly read all the blocks in that stripe and perform any fancy
calculations you like.  I may even write that tool (but no promises).

> 
> bye,
> 

Thanks,
NeilBrown
