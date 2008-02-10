From: David Greaves <david@dgreaves.com>
Subject: Re: [PATCH] Use new sb type
Date: Sun, 10 Feb 2008 12:27:25 +0000
Message-ID: <47AEEDAD.5050405@dgreaves.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479FB1FB.6040500@tmr.com> <Pine.LNX.4.64.0801292347430.14907@fbirervta.pbzchgretzou.qr> <47AED31A.3070704@dgreaves.com> <Pine.LNX.4.64.0802101311320.7176@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802101311320.7176@fbirervta.pbzchgretzou.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Bill Davidsen <davidsen@tmr.com>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On Feb 10 2008 10:34, David Greaves wrote:
>> Jan Engelhardt wrote:
>>> On Jan 29 2008 18:08, Bill Davidsen wrote:
>>>
>>>>> IIRC there was a discussion a while back on renaming mdadm options
>>>>> (google "Time to deprecate old RAID formats?") and the superblocks
>>>>> to emphasise the location and data structure. Would it be good to
>>>>> introduce the new names at the same time as changing the default
>>>>> format/on-disk-location?
>>>> Yes, I suggested some layout names, as did a few other people, and
>>>> a few changes to separate metadata type and position were
>>>> discussed. BUT, changing the default layout, no matter how "better"
>>>> it seems, is trumped by "breaks existing setups and user practice."
>>> Layout names are a different matter from what the default sb type should 
>>> be.
>> Indeed they are. Or rather should be.
>>
>> However the current default sb includes a layout element. If the default sb is
>> changed then it seems like an opportunity to detach the data format from the
>> on-disk location.
> 
> I do not see anything wrong by specifying the SB location as a metadata
> version. Why should not location be an element of the raid type?
> It's fine the way it is IMHO. (Just the default is not :)

There was quite a discussion about it.

For me the main argument is that for most people seeing superblock versions
(even the manpage terminology is version and subversion) will correlate
incremental versions with improvement.
They will therefore see v1.2 as 'the latest and best'.
We had our first 'in the wild' example just a few days ago.

Feel free to argue that the manpage is clear on this - but as we know, not
everyone reads the manpages in depth...

It's misleading and I would submit that *if* Neil decides to change the default
then changing the terminology at the same time would mean a single change that
ushers in broader benefit.

I acknowledge that I am only talking semantics - OTOH I think semantics can be a
very important aspect of communication.

David
PS I would love to send a patch to mdadm in - I am currently being heavily
nagged to sort out our house electrics and get lunch. It may happen though :)




