From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Is there a drive error "retry" parameter?
Date: Wed, 15 Jun 2005 20:20:42 -0400
Message-ID: <42B0C5DA.1040205@steeleye.com>
References: <200505021224.35396.mlaks@verizon.net> <429F2458.6070404@update.fsix.com> <429F3ED5.4020005@tls.msk.ru> <42AF51CD.7050102@update.fsix.com> <42AF5E2B.3010908@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF5E2B.3010908@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: cknowlton@science.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Carlos Knowlton wrote:

>>>> Is there a "retry" parameter that can be set in the kernel parameters,
>>>> or else in the code itself to prolong the existence of a drive in an
>>>> array before it is considered dirty?
>>>
>>>
>>> There's no such parameter currently.  But there was several discussions
>>> about how to make raid code more robust - in particular, in case of
>>> read error, raid code may keep the errored drive in the array and mark
>>> it dirty only in case of write error.
>>>
>> That would be nice.  Do you know if anyone has done any work toward 
>> such a fix?
> 
> 
> Looks like this is a "FAQ #1" candidate for linux softraid ;)
> I tried to do just that myself, with a help from Peter T. Breuer.
> The code even worked here on a test machine for some time.
> But it's umm.. quite a bit ugly, and Neil is going to slightly
> different direction (which I for one don't like much - the
> persistent bitmaps stuff, -- I think simpler approach is better).

The persistent bitmap code has got nothing to do with read/write error 
correction. The bitmap simply keeps track of what's out of sync between 
the component drives, so you never need a full resync. On the other 
hand, read/write error correction tries to limit the conditions under 
which a drive would be kicked out of an array (thus resulting in a 
resync). Ultimately, I think we'd like to see both capabilities in md, 
though...

--
Paul

