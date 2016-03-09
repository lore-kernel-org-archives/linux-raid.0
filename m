From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 4/8] Grow: Grow_addbitmap(): Add check to quiet down static code checkers
Date: Wed, 09 Mar 2016 09:00:52 -0500
Message-ID: <wrfjr3fj92ej.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<1457458252-20203-5-git-send-email-Jes.Sorensen@redhat.com>
	<56E0606E.5000906@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56E0606E.5000906@suse.com> (Guoqing Jiang's message of "Thu, 10
	Mar 2016 01:42:06 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

Guoqing Jiang <gqjiang@suse.com> writes:
> On 03/09/2016 01:30 AM, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Grow_addbitmap() is only ever called with s->bitmap_file != NULL, but
>> not all static code checkers catch this. This adds a check to quiet
>> down the false positive warnings.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>   Grow.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/Grow.c b/Grow.c
>> index 0fa776d..c453eb6 100755
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -297,7 +297,14 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
>>   			"  between different architectures.  Consider upgrading the Linux kernel.\n");
>>   	}
>>   -	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") ==
>> 0)
>> +	/*
>> +	 * We only ever get called if s->bitmap_file is != NULL, so this check
>> +	 * is just here to quiet down static code checkers.
>> +	 */
>> +	if (!s->bitmap_file)
>> +		return 1;
>
> Is it really need to make all static code checkers happy? ;-)
> Otherwise, I would prefer remove above check.
>
> Anyway, I am fine with the changes.

We had a check in one place, but not in the remaining places. I just
made it more consistent.

Making the code checker happy does make some sense because it finds
valid bugs too, and they are easier to find when we don't get a lot of
false warnings.

Thanks for your review :)

Cheers,
Jes
