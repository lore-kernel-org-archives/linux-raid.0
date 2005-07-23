From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: strange raid5
Date: Sun, 24 Jul 2005 07:37:52 +1000
Message-ID: <17122.47280.525454.526295@cse.unsw.edu.au>
References: <1122083913.24620.59.camel@localhost.localdomain>
	<42E1E03B.6030708@dtbb.net>
	<1122125925.5580.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Saturday July 23
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Tyler <pml@dtbb.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday July 23, mingz@ele.uri.edu wrote:
> 1048576 = 1024 * 1024 = 32 * 32768. :)
      ^^^
> 
> so it should be 32 stripe writes.
> 
> ming
> 
> On Fri, 2005-07-22 at 23:14 -0700, Tyler wrote:
> > By my calculations, 1048756 is *not* a multiple of 32768 (32 
                            ^^^
> > Kilobytes).  Did I miscalculate?
> > 

A typo somewhere :-)


> > Regards,
> > Tyler.
> > 
> > Ming Zhang wrote:
> > 
> > >i created a 32KB chunk size 3 disk raid5. then write this disk with a
> > >small code i wrote. i found that even i write it with 1048756 in unit,
> > >which is multiple of stripe size, it still has a lot of read when seen
> > >from iostat. 

> > >sda             605.05       387.88     35143.43        384      34792
> > >sdb             611.11       323.23     35143.43        320      34792
> > >sdc             602.02       387.88     35143.43        384      34792

I wouldn't call this "a lot of read".  The read requests are only 1%
of the write requests.  So I would call it "some read".

There is quite a lot of complexity between the 'write' system all and
the data actually getting to the device.  Presumably the Linux VM
system is flushing dirty data to the device at times other than then
end of the write request.
I think the block layer also automatically flushes devices every
200msecs.
This may be triggering flush requests which aren't stripe-aligned.

You are certainly getting the vast majority of stripes written as
whole stripes.

NeilBrown
