From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 0/8] mdadm static checker fixes
Date: Wed, 09 Mar 2016 11:30:36 -0500
Message-ID: <wrfj60wvvck3.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<877fhclgvn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877fhclgvn.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Wed, 09 Mar 2016 09:55:08 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Hi,
>>
>> I have been running mdadm through Coverity and fixed a number of
>> issues that were raised in the scan. A couple of them were non issues
>> related to conditions where we know for sure the kernel will not
>> return strings longer than a given size, but there were also a number
>> of potential memory leaks and buffer overflows.
>>
>> These patches are sitting in my pending queue. If you are on the CC
>> list, would you mind having a look at the portions touching code you
>> previously pushed wrote.
>>
>> Please hollor if you notice I did anything wrong, otherwise I'll push
>> this set into git within the next couple of days.
>
> All
>   Reviewed-by: NeilBrown <neilb@suse.com>
>
> The comments I have made are only possible enhancements, no problems
> found.
>
> I must confess that I was generally fairly careless about resource
> leakage.  mdadm usually calls 'exit' fairly soon and that releases
> everything.  But mdmon and "mdadm --monitor" at long-running so it can
> pay to be careful.  And I'm very supportive of silencing warnings from
> tools that also provide useful warnings.

Thanks for the feedback - much appreciated!

Cheers,
Jes


> Thanks!
>
> NeilBrown
>
>>
>> Cheers,
>> Jes
>>
>>
>> Jes Sorensen (8):
>>   Manage: Manage_add(): Fix memory leak
>>   load_sys(): Add a buffer size argument
>>   Grow: Grow_continue_command() remove dead code
>>   Grow: Grow_addbitmap(): Add check to quiet down static code checkers
>>   {platform,super}-intel: Fix two resource leaks
>>   bitmap: Fix resource leak in bitmap_file_open()
>>   Manage: Manage_subdevs() fix file descriptor leak
>>   super1: Fix potential buffer overflows when copying cluster_name
>>
>>  Detail.c         |  2 +-
>>  Grow.c           | 11 ++++++++---
>>  Manage.c         |  8 ++++++--
>>  bitmap.c         |  1 +
>>  mdadm.h          |  2 +-
>>  platform-intel.c |  7 ++++++-
>>  super-intel.c    | 12 ++++++++----
>>  super1.c         | 18 ++++++++++++------
>>  sysfs.c          | 47 ++++++++++++++++++++++++-----------------------
>>  9 files changed, 67 insertions(+), 41 deletions(-)
>>
>> -- 
>> 2.5.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
