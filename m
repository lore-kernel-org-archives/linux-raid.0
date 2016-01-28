From: Sarah Newman <srn@prgmr.com>
Subject: Re: mdadm bad blocks list
Date: Wed, 27 Jan 2016 19:55:04 -0800
Message-ID: <56A99118.2080508@prgmr.com>
References: <56A9102D.4030304@prgmr.com>
 <87twly1jc7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87twly1jc7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/27/2016 07:19 PM, NeilBrown wrote:
> On Thu, Jan 28 2016, Sarah Newman wrote:
> 
>> I experienced the following problems with the mdadm bad blocks list:
>>
>> 1. Additions to the bad block list do not cause an email to be sent by the mdadm monitor. Expected behavior is for an email to be sent as soon as the
>> bad blocks list becomes non-empty.
> 
> Yes, that would be a good idea.  If you do develop patches, please post
> them.

Will do, but I don't have a definite time frame for it.

> 
>> 2. /proc/mdstat does not show any indication that there are bad blocks present on an md member. Specifically, the status for the raid personality
>> should show something other than "U" if the badblocks list is not empty for that member (maybe "B"?)
> 
> I'd like to deprecate /proc/mdstat.  It is not really easy to extend.
> People might have programs that parse it which could break if you change
> 'U' to 'B'.
> I'd recommend using "mdadm" to get status of an array, or examine file
> in /sys.

If /proc/mdstat isn't going to be updated, is it going to be removed? If not and changing 'U' to 'B' isn't acceptable, then what about adding a flag
to the device? Example

md0 : active raid1 sda1[1] sdb1[2](B)

Where is the bad blocks list in /sys?

> 
>> 3. Adding a device when there is an md member with bad blocks does not appear to trigger a rebuild, meaning there could be at least one good copy of
>> all the data but no way to get all good data on a single device without expanding the entire array.
> 
> Good point.  That would be quite easy to change.  Just set
> WantReplacement if the bad block list is ever empty.
> Not sure it is always a good idea though.  You can have a bad block on a
> perfectly good device if the device it was recovered from has a bad
> block.
> You only really want to set WantReplacement automatically if a write
> fails.  We do do that, but if you stop and restart an array the fact
> that a write failed can be forgotten.

Yes, I am quite aware there can be a bad block on a perfectly good device. But in a mirror if there are multiple perfectly good devices that each have
bad blocks marked for whatever reason, the only way to get back to a single good device is to rebuild off of all of them. Speaking as a user, this is
what I would want to happen.

> I'm not convinced that it is harmful, though I accept that it is not perfect.

Yes. You both know the current behavior of mdadm perfectly and probably didn't just experience data loss.

The old behavior was to fail immediately and alert if there was a problem rather than silently accepting errors. I expect there are some people who
think they have a good RAID, but don't, based on /proc/mdstat and lack of errors from mdadm monitor.

Thanks, Sarah
