From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 21:04:00 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105210224.11158B-100000@Maggie.Linux-Consulting.com>
References: <41DC9420.5030701@h3c.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DC9420.5030701@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 5 Jan 2005, Mike Hardy wrote:

> There are those that think if they size the machine correctly, they 
> shouldn't need swap, and they're right.

bingo
 
> > I had 8 Meg of swap space.  So 12 meg total available virtual memory.
> > One day I added 16 Meg of RAM.  So now I had 20 Meg of RAM.  I deleted my
> > swap space.  Everyone told me I needed 20-40 Meg of swap space now!  Swap
> > space should be 2 time RAM size.  How crazy, my memory requirements did not
> > change, just the amount of memory.  I used that system for a year or so like
> > that.  Go figure!

the silly rule of 2x size of RAM == swap space came from the old days
when memory was 10x the costs of disks or some silly cost performance
that it made sense when grandpa was floating around

by todays ram and disk pricing ... and cpu speeds ...2x memory sorta
goes out the door

c ya
alvin

