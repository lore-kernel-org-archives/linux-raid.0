From: David Brown <david.brown@hesbynett.no>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Tue, 30 Apr 2013 20:39:40 +0200
Message-ID: <51800FEC.6020409@hesbynett.no>
References: <BA07AEDCFD3B5B4DAB0FF1D7B35E42DC5544C4B2@PRN-MBX01-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BA07AEDCFD3B5B4DAB0FF1D7B35E42DC5544C4B2@PRN-MBX01-4.TheFacebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kumar Sundararajan <kumar@fb.com>
Cc: Dan Williams <djbw@fb.com>, NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/04/13 18:10, Kumar Sundararajan wrote:
> 
> 
> On 4/30/13 9:01 AM, "Kumar Sundararajan" <kumar@fb.com> wrote:
> 
>>
>>
>> On 4/29/13 11:48 PM, "David Brown" <david.brown@hesbynett.no> wrote:
>>
>>> On 30/04/13 02:05, Dan Williams wrote:
>>>> On Mon, Apr 29, 2013 at 12:28 PM, David Brown
>>>> <david.brown@hesbynett.no> wrote:
>>>>> For each data block you are changing, you will need to remove the old
>>>>> g^i *
>>>>> Di_old then add in the new g^i * Di_new, so you can still use this
>>>>> simplification to reduce the number of multiplies.  If you want to
>>>>> change
>>>>> blocks "i" and "j", you thus do:
>>>>>
>>>>> Q_new = Q_old + g^i * (Di_old + Di_new) + g^j * (Dj_old + Dj_new)
>>>>>
>>>>> But as I say, I only know the maths - not the code.
>>>>
>>>> The issue is where to store those intermediate Di_old + Di_new results
>>>> without doubling the size of the stripe cache.
>>>>
>>>
>>> (As before, I haven't looked at the code.  I justify my laziness by
>>> claiming that I might come up with fresh ideas without how to implement
>>> things.  But only you folks can say what takes more work, and what is
>>> riskier in the code.)
>>>
>>> I don't see that you would need to double the size of the stripe cache.
>>> You might need an extra few block spaces, but not double the cache.
>>>
>>> Also, once you have done this calculation (assuming you did the easy
>>> P_new first), you no longer need to keep Di_old lying around - it's
>>> going to be replaced with the new stripe data.  So maybe you can do the
>>> operation as "Di_old += Di_new" - i.e., in place and without using more
>>> memory.  That is going to be faster too, as it is more cache friendly.
>>> On the other hand, it might involve more locking or other tracking
>>> mechanisms to avoid problems if something else is trying to access the
>>> same caches.
>>>
>>
>> Yes, I had seen your earlier mails on this topic and implemented it this
>> way initially.
>> However, this required us to either ask for stable pages or allocate an
>> extra "spare" page
>> for each disk in the array to hold the intermediate results.
> 
> Sorry, that should read -- one extra "spare" page per cpu for each disk
> in the array.
> 

Fair enough.  I suppose the "multiple by g^i" operation will be done
with a table lookup, and it's going to be pretty fast on a modern cpu
since the table will be entirely in L1 cache.



