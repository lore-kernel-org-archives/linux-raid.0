From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: Safe disk replace
Date: Thu, 6 Sep 2012 13:28:37 +1000
Message-ID: <20120906032837.GA10993@onthe.net.au>
References: <20120904041447.GB14445@onthe.net.au>
 <5045D7D9.9000108@hesbynett.no>
 <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
 <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 04, 2012 at 04:33:42PM +0100, Robin Hill wrote:
> On Tue Sep 04, 2012 at 02:26:24PM +0200, Mikael Abrahamsson wrote:
>> On Tue, 4 Sep 2012, David Brown wrote:
>> 
>>> The "raid1" copy you mention will one day be possible with "hot replace"
>>> <http://neil.brown.name/blog/20110216044002#2>
>>>
>>> I don't know how far along this idea is at the moment.
>> 
>> https://lwn.net/Articles/465048/
>> 
>> "hot-replace support for RAID4/5/6:
>> 
>> In order to activate hot-replace you need to mark the device as 
>> 'replaceable'. This happens automatically when a write error is recorded 
>> in a bad-block log (if you happen to have one).
>> 
>> It can be achieved manually by
>>     echo replaceable > /sys/block/mdXX/md/dev-YYY/state
>> 
>> This makes YYY, in XX, replaceable."
>> 
>> I don't know if it actually made it into 3.2, I believe I saw somewhere 
>> that it was available for 3.3, but Neil Brown should know more.
> 
> I'm currently upgrading my RAID-6 arrays via hot-replacement. The
> process I followed (to replace device YYY in array mdXX) is:
>     - add the new disk to the array as a spare
>     - echo want_replacement > /sys/block/mdXX/md/dev-YYY/state
> 
> That kicks off the recovery (a straight disk-to-disk copy from YYY to
> the new disk). After the rebuild is complete, YYY gets failed in the
> array, so can be safely removed:
>     - mdadm -r /dev/mdXX /dev/mdYYY
> 
> That's worked fine so far, and looks to run at the single disk write
> speed. There were no errors on the old disks though, so I've not seen
> how that gets handled (it _should_ just do a parity-based recovery from
> the remaining disks and continue).

Thanks all, this is exactly what I was looking for!

Cheers,

Chris
