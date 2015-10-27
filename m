From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] md-cluster: Only one thread should request DLM lock
Date: Tue, 27 Oct 2015 18:28:56 -0500
Message-ID: <563008B8.3070003@suse.de>
References: <1445520669-4406-1-git-send-email-rgoldwyn@suse.de>
 <874mhiz643.fsf@notabene.neil.brown.name> <562A099E.2060709@suse.de>
 <87twpcca1w.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87twpcca1w.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids



On 10/27/2015 03:48 PM, Neil Brown wrote:
> On Fri, Oct 23 2015, Goldwyn Rodrigues wrote:
>
>> On 10/22/2015 09:11 PM, Neil Brown wrote:
>>> rgoldwyn@suse.de writes:
>>>
>>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>>
>>>> If a DLM lock is in progress, requesting the same DLM lock will
>>>> result in -EBUSY. Use a mutex to make sure only one thread requests
>>>> for dlm_lock() function at a time.
>>>>
>>>> This will fix the error -EBUSY returned from DLM's
>>>> validate_lock_args().
>>>
>>> I can see that we only want one thread calling dlm_lock() with a given
>>> 'struct dlm_lock_resource' at a time, otherwise nasty things could
>>> happen.
>>>
>>> However if such a race is possible, then aren't there other possibly
>>> complications.
>>
>> This is specific to the duration of dlm_lock() function only and not the
>> entire lifetime of the resource. If one thread has requested dlm_lock()
>> and another thread comes in and calls dlm_lock() on the same resource,
>> we will get -EBUSY on the second one because the lock is already requested.
>>
>> Our dlm_unlock_sync() call is also a dlm_lock_sync(), and eventually
>> dlm_lock() call, with a NULL lock.
>>
>>>
>>> Suppose two threads try to lock the same resource.
>>> Presumably one will try to lock the resource, then the next one (when it
>>> gets the mutex) will discover that it already has the resource, but will
>>> think it has exclusive access - maybe?
>>
>> I am not sure if I understand this. DLM locks are supposed to be at the
>> node level as opposed to thread level.
>
> I think this is exactly my point.  I think we need some extra
> thread-level locking.
> For example suppose some thread calls sendmsg() which takes the token
> lock, and then while that is happening metadata_update_start() gets
> called.
> It will try to take the token lock, but as the node already has the
> lock, it will succeed trivially.  Then two threads on the one node both
> think they have the lock which will almost certainly lead to confusion.

Yes, this is the other problem I was talking about which led to the call 
trace originating in unlock_comm(). These are two separate problems, but 
your proposal of using a single mutex should resolve both. I was 
thinking more in terms of finer grained locking but it looks like an 
overkill here.

>
> So we need to hold some mutex the entire time that sendmsg() is running,
> and need to hold that same mutex when calling metadata_update_start().
> Once we have that, there is not need for the mutex you introduced which
> is just held while claiming the lock.

We may have to add flags to detect where the call is coming from, but 
yes that should be fine. I will come up with a patch soon.

>
> It could be that we can use ->reconfig_mutex for a lot of this.
> Certainly we always hold ->reconfig_mutex while performing a metadata
> update.
> We probably don't want to take it just for ->resync_info_update().

Agree here.

>
> I'm not sure if it would be best to have a per-resource mutex which we
> take in dlm_lock_sync() and drop in dlm_unlock_sync(), or if we want the
> locking at a higher level.
> Probably ->reconfig_mutex is already used where we need higher-level
> locking.
> So if you change you patch to unlock in dlm_unlock_sync() rather than
> at the end of dlm_lock_sync(), then I think it will make sense.

It is just as good as using a single mutex for all communication, so I 
would favour using a single one.

Thanks for your comments.

-- 
Goldwyn
