From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 09/12] raid5-ppl: read PPL signature from IMSM metadata
Date: Thu, 8 Dec 2016 11:36:54 +0100
Message-ID: <4cb33e5a-9672-d393-b0e3-b7f92613f08b@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
 <20161205153113.7268-10-artur.paszkiewicz@intel.com>
 <871sxk4jj0.fsf@notabene.neil.brown.name>
 <0e661d59-033e-6797-b5d1-d30cdb04ef11@intel.com>
 <87inqv2ubl.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87inqv2ubl.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/08/2016 12:27 AM, NeilBrown wrote:
> On Thu, Dec 08 2016, Artur Paszkiewicz wrote:
> 
>> On 12/07/2016 02:25 AM, NeilBrown wrote:
>>> On Tue, Dec 06 2016, Artur Paszkiewicz wrote:
>>>
>>>> The PPL signature is used to determine if the stored PPL is valid for a
>>>> given array. With IMSM, the PPL signature should match the
>>>> orig_family_num field of the superblock. To avoid passing this value
>>>> from userspace, it can be read from the IMSM MPB when initializing the
>>>> log.
>>>
>>> It is up to mdadm to determine if the PPL is valid.  It would only tell
>>> the kernel that a PPL exists if it is valid...
>>
>> The kernel also has to know this value because it writes it to the PPL
>> header. So yet another sysfs attribute just for this value? How about
>> adding a directory similar to "bitmap" to hold all the PPL related
>> settings?
> 
> There is only one PPL header (per device) - correct?
> md can read that header, change the few fields that it knows about, and
> write it back out again.  Does it ever need to change the PPL signature?
> 
> When a PPL is created, mdadm can write the initial header.
> 
> Am I missing something?

Well, you are right. If mdadm takes care of validating PPL and writes
the initial header, md can use the signature read from the header. Much
simpler that way :) Thanks for the suggestion.

Artur
