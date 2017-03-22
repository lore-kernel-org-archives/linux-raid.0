From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCHv2 2/2] super1: check and output faulty dev role
Date: Wed, 22 Mar 2017 11:23:42 +0100
Message-ID: <CAMGffEkq4_41r8LPSJnhPSFFGXBWvfOq8rfKSTAOH-qVOTqZQA@mail.gmail.com>
References: <1490003517-4216-1-git-send-email-gi-oh.kim@profitbricks.com>
 <1490003517-4216-3-git-send-email-gi-oh.kim@profitbricks.com> <877f3icslm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <877f3icslm.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>, jes.sorensen@gmail.com, linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 21, 2017 at 8:55 PM, NeilBrown <neilb@suse.com> wrote:
> On Mon, Mar 20 2017, Gioh Kim wrote:
>
>> From: Jack Wang <jinpu.wang@profitbricks.com>
>>
>> Output the real dev role in examine_super1, it will help to
>> find problem.
>>
>> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
>> Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>
>> ---
>>  super1.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/super1.c b/super1.c
>> index f3520ac..c903371 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -501,8 +501,10 @@ static void examine_super1(struct supertype *st, char *homehost)
>>  #endif
>>       printf("   Device Role : ");
>>       role = role_from_sb(sb);
>> -     if (role >= MD_DISK_ROLE_FAULTY)
>> -             printf("spare\n");
>> +     if (role == MD_DISK_ROLE_SPARE)
>> +             printf("Spare\n");
>> +     else if (role == MD_DISK_ROLE_FAULTY)
>> +             printf("Faulty\n");
>>       else if (role == MD_DISK_ROLE_JOURNAL)
>>               printf("Journal\n");
>>       else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_REPLACEMENT))
>> --
>> 2.5.0
>
> I don't think the distinction between "faulty" and "spare" is really
> useful here.  I used to report the difference and it turned out to be
> confusing, so we stopped.
>
> This is information stored on some other disk, not the one that is
> spare-or-faulty.  All it needs to know if what other devices are
> working.  It doesn't need to know about which devices aren't working and
> why.
> The distinction between 'faulty' and 'spare' is only relevant to the
> device itself, and to the array as a whole.
>
> We should probably get rid of the distinction between
> MD_DISK_ROLE_FAULTY and MD_DISK_ROLE_SPARE.
> Most places that test for it just test >= MD_DISK_ROLE_FAULTY.
>
> NeilBrown

The reason why I did this change, was during debugging the problem, we
 notice the dev_role was wrong, but
when I print in mdadm it said 'spare', which lead me to check other
kernel code path, so spent more time until, I found
examine_super1, treat >=MD_DISK_ROLE_FAULTY as 'spare'.

I thought if the output was right, it could have saved me or maybe
also other developer some time.

But if this cause confusing in the past, we can drop it, the first is
the real bugfix.

Thanks!
-- 
Jack Wang
Linux Kernel Developer
