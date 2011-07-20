From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] RAID-6 check standalone suspend array V2.0
Date: Wed, 20 Jul 2011 19:57:03 +0200
Message-ID: <4E2716EF.1050509@nexgo.de>
References: <20110321140244.2314b4b4@notabene.brown>	<20110321104007.GA15379@lazy.lzy>	<20110321220457.29d52f5c@notabene.brown>	<20110321115440.GA15635@lazy.lzy>	<20110322095905.737fb1d5@notabene.brown>	<20110404175242.GA3411@lazy.lzy>	<20110405091242.3427e0b1@notabene.brown>	<20110508185408.GA25378@lazy.lzy>	<20110509114500.116926ba@notabene.brown>	<20110509184333.GA28743@lazy.lzy>	<20110515211515.GA30260@lazy.lzy> <20110516200857.3a009a64@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110516200857.3a009a64@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

sorry for the very late answer.

On 05/16/2011 12:08 PM, NeilBrown wrote:
> On Sun, 15 May 2011 23:15:15 +0200 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
>> Hi Neil,
>>
>> reminder for the suspend patch.
>>
>> Thank you so much for the code review.
>>
>> I modified it in order to fix, hopefully, all the flaws.
>>
>> New patch attached below.
>>
>> Please note that "sigblock()" cannot be used, since it is
>> declared, at least on my system, as "deprecated".
>> Furthermore, I noticed that "Grow.c" is not checking the
>> return value of "sysfs_set_num()" while suspending the
>> array, maybe you'll need to look at this.
>>
>> Finally, please check the new patch too, while I can
>> confirm the software is doing what is supposed to do,
>> I still need support in order to confirm the suspend
>> and resume code.
>>
>> Thanks again for your help, again let me know what
>> is the next expected step.
> 
> That all looks fine thank.  I've applied it and pushed it out.
> 
> I'm not sure what you mean exactly by the 'next expected step'... 

Well, is there anything than should be done, like
documentation or code cleanup?

At the moment, it seems to me, the check itself it is
fine, maybe performance is not at best (anyone wants
to help, here?).

So, I was thinking about the "repair" process, that is
fixing the chunks which seem corrupted, instead of just
the parity.

Before I go that way, I would like to close pending issues,
if any, with the actual software.

Thanks,

bye,

pg


> Thanks,
> NeilBrown
> 
> 
>>
>> bye,
>>
>> --- cut here ---
>>
>> diff -uNr a/raid6check.c b/raid6check.c
>> --- a/raid6check.c	2011-05-07 20:35:18.693370007 +0200
>> +++ b/raid6check.c	2011-05-09 20:32:14.551695036 +0200
>> @@ -24,6 +24,8 @@
>>  
>>  #include "mdadm.h"
>>  #include <stdint.h>
>> +#include <signal.h>
>> +#include <sys/mman.h>
>>  
>>  int geo_map(int block, unsigned long long stripe, int raid_disks,
>>  	    int level, int layout);
>> @@ -99,7 +101,7 @@
>>  	return curr_broken_disk;
>>  }
>>  
>> -int check_stripes(int *source, unsigned long long *offsets,
>> +int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
>>  		  int raid_disks, int chunk_size, int level, int layout,
>>  		  unsigned long long start, unsigned long long length, char *name[])
>>  {
>> @@ -115,6 +117,8 @@
>>  	int diskP, diskQ;
>>  	int data_disks = raid_disks - 2;
>>  	int err = 0;
>> +	sighandler_t sig[3];
>> +	int rv;
>>  
>>  	extern int tables_ready;
>>  
>> @@ -139,10 +143,35 @@
>>  
>>  		printf("pos --> %llu\n", start);
>>  
>> +		if(mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
>> +			err = 2;
>> +			goto exitCheck;
>> +		}
>> +		sig[0] = signal(SIGTERM, SIG_IGN);
>> +		sig[1] = signal(SIGINT, SIG_IGN);
>> +		sig[2] = signal(SIGQUIT, SIG_IGN);
>> +		rv = sysfs_set_num(info, NULL, "suspend_lo", start * chunk_size * data_disks);
>> +		rv |= sysfs_set_num(info, NULL, "suspend_hi", (start + 1) * chunk_size * data_disks);
>>  		for (i = 0 ; i < raid_disks ; i++) {
>>  			lseek64(source[i], offsets[i] + start * chunk_size, 0);
>>  			read(source[i], stripes[i], chunk_size);
>>  		}
>> +		rv |= sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
>> +		rv |= sysfs_set_num(info, NULL, "suspend_hi", 0);
>> +		rv |= sysfs_set_num(info, NULL, "suspend_lo", 0);
>> +		signal(SIGQUIT, sig[2]);
>> +		signal(SIGINT, sig[1]);
>> +		signal(SIGTERM, sig[0]);
>> +		if(munlockall() != 0) {
>> +			err = 3;
>> +			goto exitCheck;
>> +		}
>> +
>> +		if(rv != 0) {
>> +			err = rv * 256;
>> +			goto exitCheck;
>> +		}
>> +
>>  		for (i = 0 ; i < data_disks ; i++) {
>>  			int disk = geo_map(i, start, raid_disks, level, layout);
>>  			blocks[i] = stripes[disk];
>> @@ -214,7 +243,7 @@
>>  	unsigned long long start, length;
>>  	int i;
>>  	int mdfd;
>> -	struct mdinfo *info, *comp;
>> +	struct mdinfo *info = NULL, *comp = NULL;
>>  	char *err = NULL;
>>  	int exit_err = 0;
>>  	int close_flag = 0;
>> @@ -250,6 +279,12 @@
>>  			  GET_OFFSET|
>>  			  GET_SIZE);
>>  
>> +	if(info == NULL) {
>> +		fprintf(stderr, "%s: Error reading sysfs information of %s\n", prg, argv[1]);
>> +		exit_err = 9;
>> +		goto exitHere;
>> +	}
>> +
>>  	if(info->array.level != level) {
>>  		fprintf(stderr, "%s: %s not a RAID-6\n", prg, argv[1]);
>>  		exit_err = 3;
>> @@ -343,7 +378,7 @@
>>  		comp = comp->next;
>>  	}
>>  
>> -	int rv = check_stripes(fds, offsets,
>> +	int rv = check_stripes(info, fds, offsets,
>>  			       raid_disks, chunk_size, level, layout,
>>  			       start, length, disk_name);
>>  	if (rv != 0) {
>>
>> --- cut here ---
>>
>> bye,
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

piergiorgio
