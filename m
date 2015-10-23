From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] md-cluster: Only one thread should request DLM lock
Date: Fri, 23 Oct 2015 05:19:10 -0500
Message-ID: <562A099E.2060709@suse.de>
References: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
 <874mhiz643.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874mhiz643.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids



On 10/22/2015 09:11 PM, Neil Brown wrote:
> rgoldwyn@suse.de writes:
>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> If a DLM lock is in progress, requesting the same DLM lock will
>> result in -EBUSY. Use a mutex to make sure only one thread requests
>> for dlm_lock() function at a time.
>>
>> This will fix the error -EBUSY returned from DLM's
>> validate_lock_args().
>
> I can see that we only want one thread calling dlm_lock() with a given
> 'struct dlm_lock_resource' at a time, otherwise nasty things could
> happen.
>
> However if such a race is possible, then aren't there other possibly
> complications.

This is specific to the duration of dlm_lock() function only and not the 
entire lifetime of the resource. If one thread has requested dlm_lock() 
and another thread comes in and calls dlm_lock() on the same resource, 
we will get -EBUSY on the second one because the lock is already requested.

Our dlm_unlock_sync() call is also a dlm_lock_sync(), and eventually 
dlm_lock() call, with a NULL lock.

>
> Suppose two threads try to lock the same resource.
> Presumably one will try to lock the resource, then the next one (when it
> gets the mutex) will discover that it already has the resource, but will
> think it has exclusive access - maybe?

I am not sure if I understand this. DLM locks are supposed to be at the 
node level as opposed to thread level.

>
> Then both threads will eventually try to unlock, and the second one will
> unlock something that doesn't have locked.
>
> I'm not certain, but that doesn't sound entirely safe.
>
> Which resources to we actually see races with?
>

This could happen with any resource, I have seen with ack, message, and 
token.

-- 
Goldwyn
