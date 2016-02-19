From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] super-intel: ensure suspended region is removed when reshape completes.
Date: Fri, 19 Feb 2016 17:36:34 -0500
Message-ID: <wrfjziuwcop9.fsf@redhat.com>
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

Thanks for the clarification - I'll add a documentation comment in front
of your patch then.

Cheers,
Jes
