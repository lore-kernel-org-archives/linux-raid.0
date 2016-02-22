From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] super-intel: ensure suspended region is removed when reshape completes.
Date: Mon, 22 Feb 2016 09:53:21 -0500
Message-ID: <wrfjk2lwbxum.fsf@redhat.com>
References: <871t8ar54j.fsf@notabene.neil.brown.name>
	<wrfjk2m1zvq9.fsf@redhat.com>
	<87povtptpo.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87povtptpo.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Fri, 19 Feb 2016 08:57:39 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Ken Moffat <zarniwhoop@ntlworld.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> On Fri, Feb 19 2016, Jes Sorensen wrote:
>
>> NeilBrown <neilb@suse.com> writes:
>>> A recent commit removed a call to abort_reshape() when IMSM reshape
>>> completed.  An unanticipated result of this is that the suspended
>>> region is not cleared as it should be.
>>> So after a reshape, a region of the array will cause all IO to block.
>>>
>>> Re-instate the required updates to suspend_{lo,hi} coped from
>>> abort_reshape().
>>>
>>> This is caught (sometimes) by the test suite.
>>>
>>> Also fix a couple of typos found while exploring the code.
>>>
>>> Reported-by: Ken Moffat <zarniwhoop@ntlworld.com>
>>> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>>> Fixes: 2139b03c2080 ("imsm: don't call abort_reshape() in imsm_manage_reshape()")
>>> Signed-off-by: NeilBrown <neilb@suse.com>
>>> ---
>>>  super-intel.c | 7 +++++--
>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/super-intel.c b/super-intel.c
>>> index 90b7b6dee5d0..80b48d0fdd47 100644
>>> --- a/super-intel.c
>>> +++ b/super-intel.c
>>> @@ -10465,7 +10465,7 @@ int check_degradation_change(struct mdinfo *info,
>>>   * Function:	imsm_manage_reshape
>>>   * Description:	Function finds array under reshape and it manages reshape
>>>   *		process. It creates stripes backups (if required) and sets
>>> - *		checheckpoits.
>>> + *		checkpoints.
>>>   * Parameters:
>>>   *	afd		: Backup handle (nattive) - not used
>>>   *	sra		: general array info
>>> @@ -10595,7 +10595,7 @@ static int imsm_manage_reshape(
>>>  
>>>  		start = current_position * 512;
>>>  
>>> -		/* allign reading start to old geometry */
>>> +		/* align reading start to old geometry */
>>>  		start_buf_shift = start % old_data_stripe_length;
>>>  		start_src = start - start_buf_shift;
>>>  
>>> @@ -10700,6 +10700,9 @@ static int imsm_manage_reshape(
>>>  	ret_val = 1;
>>>  abort:
>>>  	free(buf);
>>> +	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
>>> +	sysfs_set_num(sra, NULL, "suspend_hi", 0);
>>> +	sysfs_set_num(sra, NULL, "suspend_lo", 0);
>>>  
>>>  	return ret_val;
>>>  }
>>
>> This does indeed match the behavior of abort_reshape(), however looking
>> through git history, I cannot find any explanation as to why the code
>> sets suspend_lo twice.
>>
>> Any chance you can enlighten me why this is necessary?
>
> This is what I never got when I was maintainer - people insisting
> (rightly) that I explain the details...  Thanks!
>
>
> Prior to
> Commit: 23ddff3792f6 ("md: allow suspend_lo and suspend_hi to decrease
> as well as increase.")
> you could only increase suspend_{lo,hi} unless the region they covered
> was empty.  So to reset to 0, you need to push suspend_lo up past
> suspend_hi first.
> So to maximize the chance of mdadm working on all kernels, we want to keep
> doing that.
>
> Maybe you could add that to the change comment?  Or should there be a
> comment in abort_reshape()??

Applied with a one-line refererence to the documentation added in
abort_reshape().

Thanks!
Jes
