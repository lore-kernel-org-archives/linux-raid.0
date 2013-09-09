From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 2/2] DDF: new algorithm for subarray UUID
Date: Mon, 09 Sep 2013 20:37:10 +0200
Message-ID: <522E1556.4030502@arcor.de>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>	<1378502781-849-2-git-send-email-mwilck@arcor.de>	<522B7D2A.4000409@arcor.de> <20130909112041.4b8401f3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130909112041.4b8401f3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/09/2013 03:20 AM, NeilBrown wrote:
> On Sat, 07 Sep 2013 21:23:22 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> 
>> On 09/06/2013 11:26 PM, mwilck@arcor.de wrote:
>>> Some fake RAID BIOSes (in particular, LSI ones) change the
>>> VD GUID at every boot. These GUIDs are not suitable for
>>> identifying an array. Luckily the header GUID appears to
>>> remain constant.
>>>
>>> We construct a pseudo-UUID from the header GUID and those
>>> properties of the subarray that we expect to remain constant.
>>
>> Thinking about it once more, it may actually be better to construct the
>> subarray UUID only from the container GUID and the member number (and
>> name), because if we implement Grow or Reshape for DDF, the other
>> properties might change.
>>
>> I'm open for comments and suggestions.
>>
>> Martin
> 
> I'd probably just base it on the container GUID and the member number.
> Exclude even the name.

Why that? Does it make sense to expect the UUID to remain the same when
the array name has changed?

> It is unfortunate that this change will cause all existing DDF uuids to
> change even for controllers where they are currently stable.

Only for "foreign" arrays not created by MD - but see below.

> Is it possible to detect whether a VD GUID is likely to change, and to only
> use the new algorithm for those?

I am going to submit a new patch soon where I built in a vendor "black
list". This list currently contains only LSI, so the UUIDs of all
non-LSI arrays will stay the same, and for LSI, to the best of our
current knowledge, the UUIDs aren't constant anyway. I don't know
whether all LSI fake RAIDs behave like this, nor whether the Option ROMs
of other vendors do. Perhaps other people on this list can supply data
points on this.

Martin

> 
> Thanks,
> NeilBrown

