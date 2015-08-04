From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 1/2] Safeguard against writing to an active device of
 another node
Date: Tue, 04 Aug 2015 18:05:16 +0800
Message-ID: <55C08E5C.5090604@suse.com>
References: <1438601519-17919-1-git-send-email-gqjiang@suse.com> <55BF570A.6050403@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55BF570A.6050403@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goldwyn,

Thanks for review.

Goldwyn Rodrigues wrote:
>>
>> +    set_dlm_hookers(); /* get dlm funcs from libdlm_lt.so.3 */
>> +
>
> Universal Comment: Let call it set_dlm_hooks as opposed to hookers.
>
Not sure I understood correctly, the second patch used set_hookers to
call set_dlm_hookers.
>>
>>   #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>>
>> +static struct dlm_hookers *dlm_hookers = NULL;
>> +static int is_dlm_hookers_ready = 0;
>
> This should not be required, just checking for dlm_hooks == NULL
> should be enough. This needs to be set accordingly in set_dlm_hooks.
>
is_dlm_hookers_ready is introduced to check the dlm_* functions is
appeared in libdlm_lt.so.3
or not, in case there is problem within the dlm lib.

>> +static struct dlm_lock_resource *dlm_lock_res = NULL;
>> +static int ast_called = 0;
>> +
>> +struct dlm_lock_resource {
>> +    dlm_lshandle_t *ls;
>> +    struct dlm_lksb lksb;
>> +};
>> +
>> +int is_clustered(struct supertype *st)
>> +{
>> +    /* is it a cluster md or not */
>> +    if (is_dlm_hookers_ready && st->cluster_name)
>> +        return 1;
>> +    else
>> +        return 0;
>> +}
>> +
>> +/* Using poll(2) to wait for and dispatch ASTs */
>> +static int poll_for_ast(dlm_lshandle_t ls)
>> +{
>> +    struct pollfd pfd;
>
> Shouldn't you check dlm_hooks is NULL here? and starting of every
> function which requires dlm_hooks.
>
> Also, a return value from these functions do not mean an error, it
> means the library is not present.
>
I don't think so, because is_dlm_hookers_ready not only ensures 
libdlm_lt.so.3 existed and  it also make sure
all the needed dlm hookers are set. And
cluster_get_dlmlock/cluster_release_dlmlock/dlm_ast/poll_for_ast
could only be execute while is_dlm_hookers_ready is set to 1.

Thanks,
Guoqing
