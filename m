From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 13:33:01 +1100
Message-ID: <17364.16477.665959.284119@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43D42CA8.6060507@xs4all.nl>
	<17364.12454.643875.626906@cse.unsw.edu.au>
	<Pine.LNX.4.64.0601221906480.1069@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Sunday January 22
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday January 22, babydr@baby-dragons.com wrote:
>  	Hello Neil ,
> 
> On Mon, 23 Jan 2006, Neil Brown wrote:
> > On Monday January 23, hjohn@xs4all.nl wrote:
> >> NeilBrown wrote:
> >>> In line with the principle of "release early", following are 5 patches
> >>> against md in 2.6.latest which implement reshaping of a raid5 array.
> >>> By this I mean adding 1 or more drives to the array and then re-laying
> >>> out all of the data.
> >>>
> >> I think my question is already answered by this, but...
> >>
> >> Would this also allow changing the size of each raid device?  Let's say
> >> I currently have 160 GB x 6, could I change that to 300 GB x 6 or am I
> >> only allowed to add more 160 GB devices?
> >
> > Changing the size of the devices is a separate operation that has been
> > supported for a while.
> > For each device in turn, you fail it and replace it with a larger
> > device. (This means the array runs degraded for a while, which isn't
> > ideal and might be fixed one day).
> >
> > Once all the devices in the array are of the desired size, you run
> >  mdadm --grow /dev/mdX --size=max
> > and the array (raid1, raid5, raid6) will use up all available space on
> > the devices, and a resync will start to make sure that extra space is
> > in-sync.
>  	How does one come up with a accurate '--size=max' ?
>  	I thought someone had asked this question before ,  but the
>  	message where this was mentioned eluded me .
>  		Tia ,  JimL

 --size=max
is literal.  If you say 'max', mdadm will either figure out the maximum,
or tell the kernel to (I don't remember which).

NeilBrown
