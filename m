From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/8] Grow: Grow_addbitmap(): Add check to quiet down static code checkers
Date: Thu, 10 Mar 2016 18:21:03 +1100
Message-ID: <877fhakdcw.fsf@notabene.neil.brown.name>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com> <1457458252-20203-5-git-send-email-Jes.Sorensen@redhat.com> <56E0606E.5000906@suse.com> <wrfjr3fj92ej.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjr3fj92ej.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Mar 10 2016, Jes Sorensen wrote:

> Guoqing Jiang <gqjiang@suse.com> writes:
>> On 03/09/2016 01:30 AM, Jes.Sorensen@redhat.com wrote:
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>>
>>> Grow_addbitmap() is only ever called with s->bitmap_file != NULL, but
>>> not all static code checkers catch this. This adds a check to quiet
>>> down the false positive warnings.
>>>
>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>> ---
>>>   Grow.c | 9 ++++++++-
>>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Grow.c b/Grow.c
>>> index 0fa776d..c453eb6 100755
>>> --- a/Grow.c
>>> +++ b/Grow.c
>>> @@ -297,7 +297,14 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
>>>   			"  between different architectures.  Consider upgrading the Linux kernel.\n");
>>>   	}
>>>   -	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") ==
>>> 0)
>>> +	/*
>>> +	 * We only ever get called if s->bitmap_file is != NULL, so this check
>>> +	 * is just here to quiet down static code checkers.
>>> +	 */
>>> +	if (!s->bitmap_file)
>>> +		return 1;
>>
>> Is it really need to make all static code checkers happy? ;-)
>> Otherwise, I would prefer remove above check.
>>
>> Anyway, I am fine with the changes.
>
> We had a check in one place, but not in the remaining places. I just
> made it more consistent.

I wonder if maybe the checker was only complaining because the code was
inconsistent.
i.e. if we just got rid of the existing test on s->bitmap_file, maybe
that would make the checker happy.
It would be interesting to experiment even if you ultimately decide to
leave the new test there.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW4SBfAAoJEDnsnt1WYoG5ga4QAJfIOy1VrhjlyfUxD8p2A+wQ
zYbKbLMRXHBbOVP+UzMB7DhQLvIupAV3mv5Beyb8h5EDuy1yMY16lMhyl0WXu0u7
7WhVQllC6oYIQO7vZ4P9nqZH6URoQoyFjnn09Ow9C78diE4YsGHALwyvazNAVh0q
3FuHsoWWR5rGWkCp20FmHtQMWWZr9pjXrEV1B+c2zaztvCHQWx9KzawE3/kZel0A
1CMroOFRg3viH+SwyIYRZEhps1lQ5MZdQeBoRQS/aGOyj3e8+Oo6HMuoTiCZcPIe
bKBl3Ppb8CxelHdWB3H4YJDexCDGZYiuqtriWudN5q2eIxKrDkuOC+WSGjLFkIHl
3h/bheqdzDB7p7a+CmSflOrjbWTEEZfs8wdlVqFIJzXG86sP9yGJuf112K9rGbuo
XCV2U19t/JG7v6fBNIitvoVr24bFgjxGYNol/gO85CSaGOBk6LTjSbk9ZyUZqr8V
0B1SdOHa06oAVeXvFAF2gogHtrrZuFtYL/S1LPwHFLQVHmOub6zIJM1v+PDg889V
Olx/UTdODw8pIlnz1R/yiXWY9PLgY1cXGENCQ86gHO7+dGvU25ZbEj0pKEwAKKxG
WiEmlZbV36VuegdYuSX9kJbDOPufZ+LgHUxjNtV+EKyugNaW5WWg3fOIi5qjpcPQ
LFZZ1UeETOP8cS/rrHZZ
=/7a3
-----END PGP SIGNATURE-----
--=-=-=--
