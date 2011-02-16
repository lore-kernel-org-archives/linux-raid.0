From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 21:29:39 +0100
Message-ID: <20110216202939.GA2756@lazy.lzy>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

> I all,
>  I wrote this today and posted it at
> http://neil.brown.name/blog/20110216044002
> 
> I thought it might be worth posting it here too...
[...] 
> So the following is a detailed road-map for md raid for the coming
> months.

Question, is this for information purpose or are we
called to a "brainstorming"?

[...]
> Hot Replace
> -----------
> 
> "Hot replace" is my name for the process of replacing one device in an
> array by another one without first failing the one device.  Thus there

Didn't we named it also "proactive replacement"? :-)

> It is not clear whether the primary should be automatically failed
> when the rebuild of the secondary completes.  Commonly this would be
> ideal, but if the secondary experienced any write errors (that were
> recorded in the bad block log) then it would be best to leave both in
> place until the sysadmin resolves the situation.   So in the first
> implementation this failing should not be automatic.

Maybe putting the primary as "spare", i.e. not failed nor
working, unless the "migration" was not successful. In that
case the secondary device should be failed.

My use case here is disk "rotation" :-). That is, for example, a
RAID-5/6 with n disks + 1 spare. Each X months/weeks/days/hours
one disk is pulled out of the array and the spare one takes over.
The pulled out disk will be the new spare (and powered down, possibly).
The idea here is to have n disks which will have, after some time,
different (increasing) power on hours, so to minimize the possibility
of multiple failures.

> Better reporting of inconsistencies.
> ------------------------------------
> 
> When a 'check' finds a data inconsistency it would be useful if it
> was reported.   That would allow a sysadmin to try to understand the
> cause and possibly fix it.

Could you, please, consider to add, for RAID-6, the
capability to report also which device, potentially,
has the problem? Thanks!

bye,

-- 

piergiorgio
