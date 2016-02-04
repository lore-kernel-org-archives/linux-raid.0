From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [mdadm PATCH 1/1] Fix some type comparison problems
Date: Wed, 3 Feb 2016 19:10:32 -0800
Message-ID: <CABeXuvqUNw3-zQrdfaJD3fhGL0Tqc9zUU77sGAsfRdyH3QD9Jw@mail.gmail.com>
References: <1454477089-8166-1-git-send-email-xni@redhat.com>
	<wrfjr3gth6pi.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjr3gth6pi.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-raid.ids

On Wed, Feb 3, 2016 at 12:36 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Xiao Ni <xni@redhat.com> writes:
>> It complains when building on s390 and i686 platform.
>>
>> Signed-off-by : Xiao Ni <xni@redhat.com>
>> ---
>>  Monitor.c | 2 +-
>>  util.c    | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index f19c2e5..928aa45 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -542,7 +542,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>>               alert("NewArray", st->devname, NULL, ainfo);
>>       }
>>
>> -     if (st->utime == array.utime &&
>> +     if (st->utime == (long)array.utime &&
>>           st->failed == array.failed_disks &&
>>           st->working == array.working_disks &&
>>           st->spare == array.spare_disks &&
>
> Hi Xiao,
>
> Thanks for the patch - I think the correct fix in Monitor.c is to change
> utime in struct state from long to unsigned int, to match the change
> Deepa Dinamani introduced in 26714713cd2bad9e0bf7f4669f6cc4659ceaab6c
> utime is only ever derived from mdu_array_info_s, so it should be safe.
>
>> diff --git a/util.c b/util.c
>> index 970d484..ccbb2bc 100644
>> --- a/util.c
>> +++ b/util.c
>> @@ -1288,7 +1288,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
>>                       struct mdinfo info;
>>                       st->ss->getinfo_super(st, &info, NULL);
>>                       if (bestsuper == -1 ||
>> -                         besttime < info.array.ctime) {
>> +                         besttime < (time_t)info.array.ctime) {
>>                               bestsuper = i;
>>                               besttime = info.array.ctime;
>>                       }
>
> Here I think we should change the declaration of besttime from time_t to
> unsigned int, again to match the definition used in mdu_array_info_s.
>
> That or we should change mdu_array_info_s to use time_t instead, but I
> am not sure that would be safe.

It should be changed to unsigned int.
time_t is not long enough to hold timestamps after the year
2038(INT_MAX) as long is 32 bits on 32 bit systems.
It was changed to unsigned int to extend it until the year 2106.

-Deepa
