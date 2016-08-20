From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: Rewrite md raid1 member
Date: Sat, 20 Aug 2016 11:57:08 +1000
Message-ID: <20160820015708.GB30642@onthe.net.au>
References: <20160818030451.GA17225@onthe.net.au>
 <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
 <20160818040151.GA21256@onthe.net.au>
 <57B6F2F5.8090800@youngman.org.uk>
 <20160819124615.GA23247@onthe.net.au>
 <87oa4oh2m4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oa4oh2m4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Nice work on the Bus1 article!

On Sat, Aug 20, 2016 at 07:26:27AM +1000, NeilBrown wrote:
> On Fri, Aug 19 2016, Chris Dunlop wrote:
>> In my case, I want it to write everything.
>>
>> If I do my 'dd' to write everything as previously described, with the window
>> of opportunity for stale data to end up on the written disk, one option
>> would to run a scrub / repair to check the data is the same - but if I'm
>> unlucky with my dd and the data isn't the same for some sector[s], I want to
>> ensure the correct data is copied over the stale data and not the other way
>> around, e.g. to specify "in the event of a mismatch, use the data from sda
>> and overwrite the data on sdb".
>>
>> Unfortunately I don't know how that can be done.
>>
>> Does anyone know?
> 
> If it is the second device in the array (as listed by mdadm --detail)
> then you can stop the array and re-assemble with --update=resync.

That's nearly there - except in this specific case it's my root filesystem
so I can't stop the array without booting into a recovery disk etc. Of
course I could do that, but the point of the exercise is to see if it can
be done live, safely.

> If it is the first device I can only suggest that you
> fail the device and add it again:
> 
>  mdadm /dev/mdXX --fail /dev/sdYY
>  mdadm /dev/mdXX --remove /dev/sdYY
>  mdadm /dev/mdYY --add /dev/sdYY
> 
> If the "good" drive fails during the rewrite it might be a little bit
> fiddley getting the array working again, but all the data will certainly
> be there on the device you are re-writing, so you won't lose anything.

OK, that sounds good. What would the process be if the good drive fails,
either completely, or a few specific sectors?

Thanks,

Chris
