From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Extendable raid - with soft-raid 5 and new mdadm?
Date: Mon, 01 Nov 2004 17:28:16 -0800
Message-ID: <4186E2B0.6090105@h3c.com>
References: <41852F32.3000405@stefan-neufeind.de>	 <16773.36186.937623.21914@cse.unsw.edu.au> <1099356271.30526.100.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1099356271.30526.100.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Stefan Neufeind <linux-raid@stefan-neufeind.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I also had success with raidreconfig and raid5, although I had a failure 
too. I was testing it to see if a strategy of adding disks as I needed 
them would work, and I discovered that it is *very* *very* touchy about 
the size of the partitions.

Where mdadm will just use the smallest partition as the limit for all 
units in the array, raidreconfig had an error related to partition sizes 
at the very end of its attempt to grow the array.

When I made the partition sizes the exact same block size it worked 
flawlessly, though slowly, in two separate tests, one going from 2x250GB 
to 3x250, and another going from 3x250 to 4x250.

I intend to use it to grow the array semi-indefintely, but I also have 
thorough, automatic backups so I may be more cavalier than people who 
care more about a specific instance of the data.

-Mike

Doug Ledford wrote:
> On Mon, 2004-11-01 at 12:11 +1100, Neil Brown wrote:
> 
> 
>>There is a program called "raidreconfig" (I think) which can do this
>>off-line.   This is information only, not a recommendation as I have
>>never used it or looked at it.
> 
> 
> I've used it once.  It worked, it grew my raid5 array for me.  Took
> forever, but it worked.
> 

