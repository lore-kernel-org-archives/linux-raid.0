From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID creation resync behaviors
Date: Fri, 05 May 2017 08:46:51 +0200
Message-ID: <590C1FDB.5090904@hesbynett.no>
References: <20170503202748.7r243wj5h4polt6y@kernel.org> <fe3c30e4-b0dd-639e-7db7-344aa93ce198@hesbynett.no> <20170504015454.d4obiuume6e3yrdv@kernel.org> <590ADA3F.8070909@hesbynett.no> <877f1wp9o3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f1wp9o3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On 04/05/17 23:57, NeilBrown wrote:
> On Thu, May 04 2017, David Brown wrote:
> 
>>
>> I have another couple of questions that might be relevant, but I am
>> really not sure about the correct answers.
>>
>> First, if you have a stripe that you know is unused - it has not been
>> written to since the array was created - could the raid layer safely
>> return all zeros if an attempt was made to read the stripe?
> 
> "know is unused" and "it has not been written to since the array was
> created" are not necessarily the same thing.
> 
> If I have some devices which used to have a RAID5 array but for which
> the metadata got destroyed, I might carefully "create" a RAID5 over the
> devices and then have access to my data.  This has been done more than
> once - it is not just theoretical.

That is true, of course - anything like this would have to be optional
(command line switches in mdadm, for example).

There is also the opposite situation - when you /have/ had something
written to the array, but now you know it is unused (due to a trim).
Knowing the stripe is unused might make a later partial write a little
faster, and it would certainly speed up a scrub or other consistency
check since unused stripes can be skipped.

> 
> But if you really "know" it is unused, then returning zeros should be fine.
> 
>>
>> Second, when syncing an unused stripe (such as during creation), rather
>> than reading the old data and copying it or generating parities, could
>> we simply write all zeros to all the blocks in the stripes?  For many
>> SSDs, this is very efficient.
> 
> If you were happy to destroy whatever was there before (see above
> recovery example for when you wouldn't), then it might be possible to
> make this work.

As above, this would have to be option-controlled.  (I have had occasion
to pull disks from one dead server to recover them on another machine -
it's nerve-racking enough at the best of times, without fearing that you
will zero out your remaining good disks!)

> You would need to be careful not to write zeros over a region that the
> filesystem has already used.

Yes, but that should not be a difficult problem - the array is created
before the filesystem.

> That means you either disable all writes until the initialization
> completes (waste of time), or you add complexity to track which strips
> have been written and which haven't, and only initialise strips that have
> not been written.  This complexity would only be used once in the entire
> life of the RAID.  That might not be best use of resources.
> 

I am not sure I see how this would be a problem.  But it is something
that would need to be considered carefully when looking at details of
implementing these ideas (if anyone thinks they would be worth
implementing).

mvh.,

David

