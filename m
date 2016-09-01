From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: md-cluster Module Requirement
Date: Thu, 1 Sep 2016 11:45:34 -0400
Message-ID: <CAHkw+LdqRJ0xh94hHrVkuK3=ykG3gKdUtT6V4GKtVmDmCzPJ6g@mail.gmail.com>
References: <CAHkw+Lf82YEZ3qm9KJ_b_2pUiNFh=nDeEBXYV5PdgtEUtij8eg@mail.gmail.com>
 <57C79011.9090404@suse.com> <87h9a0cgkw.fsf@notabene.neil.brown.name>
 <57C7F534.3040400@suse.com> <877favdh9z.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877favdh9z.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks; I assume an updated patch will ensue? If so, I'll hang tight
for that and test it once posted.

--Marc

On Thu, Sep 1, 2016 at 6:51 AM, NeilBrown <neilb@suse.com> wrote:
> On Thu, Sep 01 2016, Guoqing Jiang wrote:
>
>>
>> Thanks, how about below changes?
>>
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -7619,20 +7619,19 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
>>
>>   int md_setup_cluster(struct mddev *mddev, int nodes)
>>   {
>> -       int err;
>> -
>> -       err = request_module("md-cluster");
>> -       if (err) {
>> -               pr_err("md-cluster module not found.\n");
>> -               return -ENOENT;
>> -       }
>> -
>>          spin_lock(&pers_lock);
>> -       if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
>> -               spin_unlock(&pers_lock);
>> -               return -ENOENT;
>> +       if (!md_cluster_ops) {
>> +               /* load module and ensure it won't be unloaded */
>> +               if (!request_module("md-cluster") &&
>
> Calling request_module() under a spin_lock is not OK.  request_module()
> needs to wait while the module is loaded.
>
> Just call request_module, ignore the error, then take the spinlock and
> see if the module is registered.
>
> NeilBrown
>
>> +                   !try_module_get(md_cluster_mod)) {
>> +                       pr_err("md-cluster module found.\n");
>> +                       spin_unlock(&pers_lock);
>> +               } else {
>> +                       pr_err("md-cluster module not found.\n");
>> +                       spin_unlock(&pers_lock);
>> +                       return -ENODEV;
>> +               }
>>          }
>> -       spin_unlock(&pers_lock);
>>
>>          return md_cluster_ops->join(mddev, nodes);
>>   }
>>
>>>>> I looked at linux-next and it appears this code is the same; is there
>>>>> a test we can do before attempting to load the module in the case that
>>>>> its built-in, or is there some other requirement that md-cluster needs
>>>>> to be built as a module?
>>>> Yes, we need some additional modules corosync/pacemaker and dlm,
>>> That doesn't explain the error message though.
>>
>> You are right, I should read carefully :(
>>
>>> If MD_CLUSTER is built in, then DLM must be too.
>>
>> Sure,  then only need to ensure cluster is configured right.
>>
>> Best Regards,
>> Guoqing
