From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 4/8] Grow: Grow_addbitmap(): Add check to quiet down static code checkers
Date: Thu, 10 Mar 2016 11:40:35 -0500
Message-ID: <wrfjmvq61e2k.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<1457458252-20203-5-git-send-email-Jes.Sorensen@redhat.com>
	<56E0606E.5000906@suse.com> <wrfjr3fj92ej.fsf@redhat.com>
	<877fhakdcw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877fhakdcw.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Thu, 10 Mar 2016 18:21:03 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Thu, Mar 10 2016, Jes Sorensen wrote:
>
>> Guoqing Jiang <gqjiang@suse.com> writes:
>>> On 03/09/2016 01:30 AM, Jes.Sorensen@redhat.com wrote:
>>>> @@ -297,7 +297,14 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
>>>>   			"  between different architectures.  Consider upgrading the Linux kernel.\n");
>>>>   	}
>>>>   -	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") ==
>>>> 0)
>>>> +	/*
>>>> +	 * We only ever get called if s->bitmap_file is != NULL, so this check
>>>> +	 * is just here to quiet down static code checkers.
>>>> +	 */
>>>> +	if (!s->bitmap_file)
>>>> +		return 1;
>>>
>>> Is it really need to make all static code checkers happy? ;-)
>>> Otherwise, I would prefer remove above check.
>>>
>>> Anyway, I am fine with the changes.
>>
>> We had a check in one place, but not in the remaining places. I just
>> made it more consistent.
>
> I wonder if maybe the checker was only complaining because the code
> was inconsistent.  i.e. if we just got rid of the existing test on
> s->bitmap_file, maybe that would make the checker happy.  It would be
> interesting to experiment even if you ultimately decide to leave the
> new test there.

I went back and checked the scan logs and it basically complained about
all the cases that didn't check the validity of s->bitmap_file. I think
it's safer to just have the one check at the top, even if we expect it
never to be called with an invalid pointer.

Cheers,
Jes
