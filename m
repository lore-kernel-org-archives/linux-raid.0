From: Tony Mantler <nicoya@ubb.ca>
Subject: Re: Concatenation with redundancy
Date: Tue, 7 Sep 2004 14:16:12 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <61F52B70-0102-11D9-94CF-0005023722B8@ubb.ca>
References: <200409071909.i87J9N321438@watkins-home.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200409071909.i87J9N321438@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 7-Sep-04, at 2:09 PM, Guy wrote:

> I can see how this would be useful.
> Being able to add disks over time, and of different sizes.
> The parity disk would be the biggest.
> Disks tend to get larger over time.  So, when you add a disk it will 
> tend to
> be larger than any of the others.  The current parity would be re-used 
> to
> extend the size, and the new disk would become the new parity.

Exactly.


> What would happen when you replace a failed disk with a new larger 
> disk?
> Just waste the extra space?

Probably, but it's easy to find small disks on eBay and the like. It's 
no worse than replacing a failed drive in a homogeneous array.


> The performance would not be too good.  Like raid5 on a real real bad 
> day!

That's true. However, writes would be fairly rare for the application 
of a media library, with most of the accesses being read-only.


> I don't like concatenated disks.  You can't balance the load on the 
> drives.
> I would never use this feature if it did exist.  But, some would love 
> it I
> bet.

It's much easier to add space to a concatenated set though, and single 
drive performance is easily sufficient for the media library 
application.


Cheers - Tony 'Nicoya' Mantler :)

--
Tony 'Nicoya' Mantler -- Master of Code-fu -- nicoya@ubb.ca
--  http://nicoya.feline.pp.se/  --  http://www.ubb.ca/  --

