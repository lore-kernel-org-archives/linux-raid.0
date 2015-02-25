From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 3/5] add_orom(): Compare content of struct imsm_orom rather than pointers to it
Date: Wed, 25 Feb 2015 12:15:58 -0500
Message-ID: <wrfj1tld3oa9.fsf@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
	<1424811640-26569-4-git-send-email-Jes.Sorensen@redhat.com>
	<54EDA91E.5050005@intel.com> <wrfjvbiq2mzo.fsf@redhat.com>
	<54EDF91F.40200@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54EDF91F.40200@intel.com> (Artur Paszkiewicz's message of "Wed,
	25 Feb 2015 17:32:31 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> On 02/25/2015 01:29 PM, Jes Sorensen wrote:
>> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>>> On 02/24/2015 10:00 PM, Jes.Sorensen@redhat.com wrote:
>>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>>
>>>> This avoids adding the same orom entry to the oroms list multiple
>>>> times, as the comparison of pointers is never going to succeed, in
>>>> particular when '*orom' points to a local stack variable in the
>>>> calling function.
>>>>
>>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>> ---
>>>>  platform-intel.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/platform-intel.c b/platform-intel.c
>>>> index 37274da..a4ffa9f 100644
>>>> --- a/platform-intel.c
>>>> +++ b/platform-intel.c
>>>> @@ -255,8 +255,8 @@ static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
>>>>  	int i;
>>>>  
>>>>  	for (i = 0; i < SYS_DEV_MAX; i++) {
>>>> -		if (&oroms[i].orom == orom)
>>>> -			return orom;
>>>> +		if (!memcmp(&oroms[i].orom, orom, sizeof(struct imsm_orom)))
>>>> +			return &oroms[i].orom;
>>>>  		if (oroms[i].orom.signature[0] == 0) {
>>>>  			oroms[i].orom = *orom;
>>>>  			return &oroms[i].orom;
>>>>
>>>
>>> Hi Jes,
>>>
>>> You are right that this can add the same entry multiple times, but this
>>> is how it is supposed to work. The oroms list should contain all the
>>> platform's oroms and they can be the same, this is why memcmp() should
>>> not be used here. We don't want to compare the contents of the
>>> structure, just its address. Sorry if it's not clear.
>> 
>> Artur,
>> 
>> Then the code is fundamentally broken, since you end up comparing a
>> stack variable against the oroms array when you call it from
>> find_imsm_efi(). Worse you can end up returning the local stack variable
>> declared in find_imsm_efi() to the calling function - there is no way
>> that can be correct.
>> 
>> Look at this:
>> 
>> static const struct imsm_orom *add_orom(const struct imsm_orom *orom)
>> {
>>         int i;
>> 
>>         for (i = 0; i < SYS_DEV_MAX; i++) {
>>                 if (&oroms[i].orom == orom)
>>                         return orom;
>>                 if (oroms[i].orom.signature[0] == 0) {
>>                         oroms[i].orom = *orom;
>>                         return &oroms[i].orom;
>>                 }
>>         }
>>         return NULL;
>> }
>> 
>> const struct imsm_orom *find_imsm_efi(struct sys_dev *hba)
>> {
>>         struct imsm_orom orom;
>>         const struct imsm_orom *ret;
>>         int err;
>> 
>> ....
>> 
>>         ret = add_orom(&orom);
>>         add_orom_device_id(ret, hba->dev_id);
>> 
>>         return ret;
>> }
>
> I can't see how this can lead to returning a stack variable. The oroms
> array is global and add_orom() will always return a pointer to a struct
> in this array. This comparison will always fail when we pass a pointer
> to a stack variable to add_orom():
>
> if (&oroms[i].orom == orom)
> 	return orom;
>
> This was meant to prevent adding an orom again like this:
>
> ret = add_orom(&orom);
> add_orom(ret);
>
> Maybe it would be more appropriate to return NULL to indicate that
> nothing was added instead of returning back the same pointer. I can do a
> patch for this. What do you think?

It will fail because we know we're comparing a stack pointer, but it
raises red flags with tools like coverity and it is really bad coding
practice to rely on hacks like this.

I also don't understand why you want to keep a table of identical
entries in the orom structure if multiple identical entries are found.
Each entry ought to match onto a specific physical controller, unless I
get something wrong?

Cheers,
Jes
