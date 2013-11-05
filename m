From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 05 Nov 2013 23:31:10 +1100
Message-ID: <5278E50E.90808@websitemanagers.com.au>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/11/13 23:02, Ivan Lezhnjov IV wrote:
> On Nov 5, 2013, at 1:36 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
> 
>> The problem is if you ignore the different contents, for those small
>> sections of disk (which are sections which were actually written to
>> recently with live data) you will get different content depending on
>> which disk you read, up until that section is re-written.
> 
> Sounds like we are assuming /dev/sdd1 in my situation has the newest data simply by virtue of being recognized as "fresh" by mdadm? Does this assumption represent the actual state of data in terms of that it is indeed the most recent version possible prior to array failure? Or is it more like this is the only option there is and it's better than nothing?

The Event count is higher for sdd1, which means md was able to
successfully write to the drive more recently. Therefore, it is
definitely "fresher" or more recent or newer.

>> The
>> alternative is to force the array, then run a check, and then a repair.
>> This will at least allow you to get consistent data regardless of which
>> disk you read from, however, you won't determine whether it is the
>> "newer" or "older" data (md will choose at random AFAIK).
> 
> What are these check and repair commands that you refer to when talking about forcing an array? Are they echo check|repair > /sys/block/mdX/md/sync_action ?

Yes, I didn't look it up, but that looks right.

> When you say force the array, does it translate to a different set of commands than what you showed in the very first reply? What would be those? I'm just curious to see how these things are done when managing the arrays, and examples help a lot!

Yes, there are other ways (which I've never used, just seen people on
this list talk about them) that will force the event count on the older
device up to the newer one, and then md will accept both drives as being
up to date etc. Effectively it just lies and pretends that the data is
correct, forcing the metadata (MD data) to match, but the actual user
data (complete content of the drives) may not match and is not checked.

I won't provide advise on this because I've never done it...

BTW, you haven't mentioned what data is actually on the array (if any),
what you are using it for, or how you got into this state.

Depending on your array usage, you may or may not want to use bitmaps,
and there might be other performance options to tune.

Depending on the current content of the array (with such low event
numbers, it looks like you may not have put data on yet, it might be
easier to just re-create the array (although that will do a resync
anyway, unless you force that to be skipped).

Finally, it would be a good idea to work out how you reached this point.
You really want to avoid having this problem in 6 months when you have
1.8TB of data on the drives....

Hope this helps.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
