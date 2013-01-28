From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 20:18:25 +0100
Message-ID: <20130128191825.GA13803@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
 <20130128173704.GA2329@lazy.lzy>
 <20130128190035.D943A294BAB@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130128190035.D943A294BAB@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 28, 2013 at 08:00:35PM +0100, Wolfgang Denk wrote:
> Dear Piergiorgio,
> 
> In message <20130128173704.GA2329@lazy.lzy> you wrote:
> >
> > I would shamelessly suggest to try "raid6check", in order
> > to see if some components have problems.
> > 
> > The software is somehow buried into "mdadm" source code,
> > probably you'll need to take it from the repository.
> 
> Found it.  Thanks for the suggestion.
> 
> However, this is extreme verbose:
> 
> layout: 2
> disks: 8
> component size: 249108103168
> total stripes: 15204352
> chunk size: 16384
> 
> disk: 0 - offset: 134217728 - size: 250864926720 - name: /dev/sdk1 -
> slot: 5
> disk: 1 - offset: 134217728 - size: 250864926720 - name: /dev/sdj1 -
> slot: 4
> disk: 2 - offset: 134217728 - size: 250864926720 - name: /dev/sdi1 -
> slot: 7
> disk: 3 - offset: 134217728 - size: 250864926720 - name: /dev/sdh1 -
> slot: 3
> disk: 4 - offset: 134217728 - size: 250864926720 - name: /dev/sdg1 -
> slot: 2
> disk: 5 - offset: 134217728 - size: 250864926720 - name: /dev/sdf1 -
> slot: 1
> disk: 6 - offset: 134217728 - size: 250864926720 - name: /dev/sde1 -
> slot: 6
> disk: 7 - offset: 134217728 - size: 250863844352 - name: /dev/sdd1 -
> slot: 0
> 
> pos --> 0
> 0->1
> 1->2
> 2->3
> 3->4
> 4->5
> 5->6
> pos --> 1
> 0->0
> 1->1
> 2->2
> 3->3
> 4->4
> 5->5
> pos --> 2
> 0->7
> 1->0
> 2->1
> 3->2
> 4->3
> 5->4
> pos --> 3
> 0->6
> 1->7
> 2->0
> 3->1
> 4->2
> 5->3
> pos --> 4
> 0->5
> 1->6
> 2->7
> 3->0
> 4->1
> 5->2
> pos --> 5
> ...
> 
> etc. ad nauseam.  I guess "pos" means stripe here, so it would print
> this for all stripes in the array?  Does this means all of them are
> broken?  Or what would I  have to look for to see where an error
> mightbe?

Hi Wolfgang,

the output is indeed verbose, my suggestion would be
to redirect it to a file (on different storage) and
"grep" later for "Error".
This should report if a specific device is detected
with problems or if it cannot detect which device.

The output you see above means everything is correct,
until stripe 4, at least. So you're right, the "pos"
is the stripe position.

In case of error, something like:

Error detected at X: possible failed disk slot: Y

Which means stripe X, disk Y, from the initial print.

Or it could be:

Error detected at X: disk slot unknown

Which should be obvious.

Hope this helps,

bye,

-- 

piergiorgio
