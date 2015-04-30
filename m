From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 01/10] Add nodes option while creating md
Date: Thu, 30 Apr 2015 10:33:59 +0800
Message-ID: <55419497.3020100@suse.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-2-git-send-email-gqjiang@suse.com> <20150429113008.253c02f7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429113008.253c02f7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, 24 Apr 2015 15:30:32 +0800 gqjiang@suse.com wrote:
>
>   
>> From: Guoqing Jiang <gqjiang@suse.com>
>>
>> Specifies the maximum number of nodes in the cluster that may use
>> this device simultaneously. This is equivalent to the number of
>> bitmaps created in the internal superblock (patches to follow).
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>     
>
> This doesn't really make much sense coming first in the series.  It sets up a
> value that is never used.
>
> I would much rather 03/10 came first - which would just create 4 bitmaps.
> Then have this patch to allow that '4' to be changed.
>
>
>   
Ok, I will re-arrange them, make 03 first, and keep the others with
original sequence.
>> ---
>>  Create.c   |  1 +
>>  ReadMe.c   |  1 +
>>  mdadm.8.in |  5 +++++
>>  mdadm.c    | 20 +++++++++++++++++++-
>>  mdadm.h    |  3 +++
>>  5 files changed, 29 insertions(+), 1 deletion(-)
>>
>> diff --git a/Create.c b/Create.c
>> index ef28da0..b73f6cb 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -531,6 +531,7 @@ int Create(struct supertype *st, char *mddev,
>>  				st->ss->name);
>>  		warn = 1;
>>  	}
>> +	st->nodes = c->nodes;
>>  
>>  	if (warn) {
>>  		if (c->runstop!= 1) {
>> diff --git a/ReadMe.c b/ReadMe.c
>> index 87a4916..30c569d 100644
>> --- a/ReadMe.c
>> +++ b/ReadMe.c
>> @@ -140,6 +140,7 @@ struct option long_options[] = {
>>      {"homehost",  1, 0,  HomeHost},
>>      {"symlinks",  1, 0,  Symlinks},
>>      {"data-offset",1, 0, DataOffset},
>> +    {"nodes",1, 0, Nodes},
>>  
>>      /* For assemble */
>>      {"uuid",      1, 0, 'u'},
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index a630310..bd8d59e 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -966,6 +966,11 @@ However for RAID0, it is not possible to add spares.  So to increase
>>  the number of devices in a RAID0, it is necessary to set the new
>>  number of devices, and to add the new devices, in the same command.
>>  
>> +.TP
>> +.BR \-\-nodes
>> +Specify the maximum number of nodes in the cluster that will use this
>> +device simultaneously. If not specified, this defaults to 4.
>> +
>>     
>
> I think this should mention that it only makes sense with --bitmap=cluster
> (which of course isn't available at this point....)
>
>
>   
Will add it.
>>  .SH For assemble:
>>  
>>  .TP
>> diff --git a/mdadm.c b/mdadm.c
>> index 3e8c49b..bce6a76 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -588,7 +588,14 @@ int main(int argc, char *argv[])
>>  			}
>>  			ident.raid_disks = s.raiddisks;
>>  			continue;
>> -
>> +		case O(CREATE, Nodes):
>> +			c.nodes = parse_num(optarg);
>> +			if (c.nodes <= 0) {
>> +				pr_err("invalid number for the number of "
>> +						"cluster nodes: %s\n", optarg);
>> +				exit(2);
>> +			}
>> +			continue;
>>  		case O(CREATE,'x'): /* number of spare (eXtra) disks */
>>  			if (s.sparedisks) {
>>  				pr_err("spare-devices set twice: %d and %s\n",
>> @@ -1377,6 +1384,17 @@ int main(int argc, char *argv[])
>>  	case CREATE:
>>  		if (c.delay == 0)
>>  			c.delay = DEFAULT_BITMAP_DELAY;
>> +
>> +		if (!strncmp(s.bitmap_file, "internal", 9) ||
>> +			!strncmp(s.bitmap_file,"none", 4)) {
>>     
>
> I'm sorry but I absolutely *hate* this construct.
> The '!' at the front makes it seem like you are testing that the string does
> *not* have that value, but it is exactly the reverse.
> And why "strncmp" rather than "strcmp" ??
>
> Please use
>
>     if (strcmp(s.bitmap_file, "internal") == 0 ||
>         strcmp(s.bitmap_file, "none) == 0) {
>
> except.... what about if bitmap_file in /path/to/somewhere.  Presumably you
> want to exclude that case too.
> May be
>    if (strcmp(s.bitmap_file, "cluster") != 0) {
> ??
>   
Thanks,  which is better for understanding.

Regards,
Guoqing
