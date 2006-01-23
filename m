From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Mon, 23 Jan 2006 12:25:58 +1100
Message-ID: <17364.12454.643875.626906@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43D42CA8.6060507@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Hendrikx on Monday January 23
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Monday January 23, hjohn@xs4all.nl wrote:
> NeilBrown wrote:
> > In line with the principle of "release early", following are 5 patches
> > against md in 2.6.latest which implement reshaping of a raid5 array.
> > By this I mean adding 1 or more drives to the array and then re-laying
> > out all of the data.
> >   
> I think my question is already answered by this, but...
> 
> Would this also allow changing the size of each raid device?  Let's say 
> I currently have 160 GB x 6, could I change that to 300 GB x 6 or am I 
> only allowed to add more 160 GB devices?

Changing the size of the devices is a separate operation that has been
supported for a while.
For each device in turn, you fail it and replace it with a larger
device. (This means the array runs degraded for a while, which isn't
ideal and might be fixed one day).

Once all the devices in the array are of the desired size, you run
  mdadm --grow /dev/mdX --size=max
and the array (raid1, raid5, raid6) will use up all available space on
the devices, and a resync will start to make sure that extra space is
in-sync.

NeilBrown
