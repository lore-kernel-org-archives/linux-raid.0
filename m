From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] md/raid0: add config parameters to specify zone layout
Date: Mon, 27 Apr 2020 17:10:19 -0400
Message-ID: <8feb2018-7f99-6e02-c704-9d7fed40bba2@akamai.com>
References: <1585236500-12015-1-git-send-email-jbaron@akamai.com>
 <0b7aad8b-f0b7-24c6-ad19-99c6202a3036@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0b7aad8b-f0b7-24c6-ad19-99c6202a3036@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, songliubraving@fb.com
Cc: agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids



On 4/25/20 12:31 AM, Coly Li wrote:
> On 2020/3/26 23:28, Jason Baron wrote:
>> Let's add some CONFIG_* options to directly configure the raid0 layout
>> if you know in advance how your raid0 array was created. This can be
>> simpler than having to manage module or kernel command-line parameters.
>>
> 
> Hi Jason,
> 
> If the people who compiling the kernel is not the end users, the
> communication gap has potential risk to make users to use a different
> layout for existing raid0 array after a kernel upgrade.
> 
> If this patch goes into upstream, it is very probably such risky
> situation may happen.
> 
> The purpose of adding default_layout is to let *end user* to be aware of
> they layout when they use difference sizes component disks to assemble
> the raid0 array, and make decision which layout algorithm should be
> used. Such situation cannot be decided in kernel compiling time.

I agree that in general it may not be known at compile time. Thus,
I've left the default as RAID0_LAYOUT_NONE. However, there are
use-cases where it is known at compile-time which layout is needed.
In our use-case, we knew that we didn't have any pre-3.14 raid0
arrays. Thus, we can safely set RAID0_ALT_MULTIZONE_LAYOUT. So
this is a simpler configuration for us than setting module or command
line parameters.

Thanks,

-Jason

> 
>> If the raid0 array was created by a pre-3.14 kernel, use
>> RAID0_ORIG_LAYOUT. If the raid0 array was created by a 3.14 or newer
>> kernel then select RAID0_ALT_MULTIZONE_LAYOUT. Otherwise, the default
>> setting is RAID0_LAYOUT_NONE, in which case the current behavior of
>> needing to specify a module parameter raid0.default_layout=1|2 is
>> preserved.
>>
> 
> The difficulty is for a given md raid0 array, there is no clue whether
> it is built on pre-3.14 kernel or not. If the kernel is not configured
> and built by end user, we have risk that wrong algorithm will be applied
> to unmatched layout.
>> Thanks.
> 
> Coly Li
> 
> 
>> Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>> Cc: NeilBrown <neilb@suse.de>
>> Cc: Song Liu <songliubraving@fb.com>
>> Signed-off-by: Jason Baron <jbaron@akamai.com>
>> ---
>>  drivers/md/Kconfig | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/md/raid0.c |  7 +++++++
>>  2 files changed, 62 insertions(+)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index d6d5ab2..c0c6d82 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -79,6 +79,61 @@ config MD_RAID0
>>  
>>  	  If unsure, say Y.
>>  
>> +choice
>> +	prompt "RAID0 Layout"
>> +	default RAID0_LAYOUT_NONE
>> +	depends on MD_RAID0
>> +	help
>> +	  A change was made in Linux 3.14 that unintentinally changed the
>> +	  the layout for RAID0. This can result in data corruption if a pre-3.14
>> +	  and a 3.14 or later kernel both wrote to the array. However, if the
>> +	  devices in the array are all of the same size then the layout would
>> +	  have been unaffected by this change, and there is no risk of data
>> +	  corruption from this issue.
>> +
>> +	  Unfortunately, the layout can not be determined by the kernel. If the
>> +	  array has only been written to by a 3.14 or later kernel its safe to
>> +	  set RAID0_ALT_MULTIZONE_LAYOUT. If its only been written to by a
>> +	  pre-3.14 kernel its safe to select RAID0_ORIG_LAYOUT. If its been
>> +	  written by both then select RAID0_LAYOUT_NONE, which will not
>> +	  configure the array. The array can then be examined for corruption.
>> +
>> +	  For new arrays you may choose either layout version. Neither version
>> +	  is inherently better than the other.
>> +
>> +	  Alternatively, these parameters can also be specified via the module
>> +	  parameter raid0.default_layout=<N>. N=2 selects the 'new' or multizone
>> +	  layout, while N=1 selects the 'old' layout or original layout. If
>> +	  unset the array will not be configured.
>> +
>> +	  The layout can also be written directly to the raid0 array via the
>> +	  mdadm command, which can be auto-detected by the kernel. See:
>> +	  <https://www.kernel.org/doc/html/latest/admin-guide/md.html#multi-zone-raid0-layout-migration>
>> +
>> +config RAID0_ORIG_LAYOUT
>> +	bool "raid0 layout for arrays only written to by a pre-3.14 kernel"
>> +	help
>> +	  If the raid0 array was only created and written to by a pre-3.14 kernel.
>> +
>> +config RAID0_ALT_MULTIZONE_LAYOUT
>> +	bool "raid0 layout for arrays only written to be a 3.14 or newer kernel"
>> +	help
>> +	  If the raid0 array was only created and written to by a 3.14 or later
>> +	  kernel.
>> +
>> +config RAID0_LAYOUT_NONE
>> +	bool "raid0 layout must be specified via a module parameter"
>> +	help
>> +	  If a raid0 array was written to by both a pre-3.14 and a 3.14 or
>> +	  later kernel, you may have data corruption. This option will not
>> +	  auto configure the array and thus you can examine the array offline
>> +	  to determine the best way to proceed. With RAID0_LAYOUT_NONE
>> +	  set, the choice for raid0 layout can be set via a module parameter
>> +	  raid0.default_layout=<N>. Or the layout can be written directly
>> +	  to the raid0 array via the mdadm command.
>> +
>> +endchoice
>> +
>>  config MD_RAID1
>>  	tristate "RAID-1 (mirroring) mode"
>>  	depends on BLK_DEV_MD
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 322386f..576eaa6 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -19,7 +19,14 @@
>>  #include "raid0.h"
>>  #include "raid5.h"
>>  
>> +#if defined(CONFIG_RAID0_ORIG_LAYOUT)
>> +static int default_layout = RAID0_ORIG_LAYOUT;
>> +#elif defined(CONFIG_RAID0_ALT_MULTIZONE_LAYOUT)
>> +static int default_layout = RAID0_ALT_MULTIZONE_LAYOUT;
>> +#else
>>  static int default_layout = 0;
>> +#endif
>> +
>>  module_param(default_layout, int, 0644);
>>  
>>  #define UNSUPPORTED_MDDEV_FLAGS		\
>>
> 
