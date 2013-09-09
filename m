From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Mon, 09 Sep 2013 20:31:11 +0200
Message-ID: <522E13EF.3080001@arcor.de>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de> <20130909111546.2e9551b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130909111546.2e9551b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

>> Print an array name in brief output. Do this even if no name is set,
>> faking a simple pseudo name (may happen for some BIOS RAIDs).
>> This makes DDF and IMSM behave equally.
>>
>> SUSE's YaST2 needs this in order to detect MD arrays during
>> installation.
> 
> Thanks, but I don't like this - I would really rather SUSE's YaST2 got fixed.
> 
> mdadm.conf is really for mdadm to read.  And the "--brief" output is meant
> for inclusion in mdadm.conf.
> 
> If other programs want to parse the output of mdadm, they should use
> --export, not --brief.

Well, yast is actually not calling --brief. It calls "mdadm --examine
--scan", and --scan implies --brief (comment in mdadm.c). My patch
simply causes DDF and IMSM to print similar output with "mdadm -Es".
Isn't that reasonable?

Martin


> 
> NeilBrown
> 
>>
>> Signed-off-b545d3bca8b105ba10dadbab2fcd31467b5613c11y: Martin Wilck <mwilck@arcor.de>
>> ---
>>  super-ddf.c |   13 +++++++++++--
>>  1 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/super-ddf.c b/super-ddf.c
>> index 8bba70a..72a8351 100644
>> --- a/super-ddf.c
>> +++ b/super-ddf.c
>> @@ -30,6 +30,7 @@
>>  #include "mdmon.h"
>>  #include "sha1.h"
>>  #include <values.h>
>> +#include <ctype.h>
>>  
>>  /* a non-official T10 name for creation GUIDs */
>>  static char T10[] = "Linux-MD";
>> @@ -1577,14 +1578,22 @@ static void brief_examine_subarrays_ddf(struct supertype *st, int verbose)
>>  		struct virtual_entry *ve = &ddf->virt->entries[i];
>>  		struct vcl vcl;
>>  		char nbuf1[64];
>> +		char namebuf[sizeof(ve->name)+1], *c;
>>  		if (all_ff(ve->guid))
>>  			continue;
>>  		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
>>  		ddf->currentconf =&vcl;
>>  		uuid_from_super_ddf(st, info.uuid);
>>  		fname_from_uuid(st, &info, nbuf1, ':');
>> -		printf("ARRAY container=%s member=%d UUID=%s\n",
>> -		       nbuf+5, i, nbuf1+5);
>> +		memcpy(namebuf, ve->name, sizeof(ve->name));
>> +		namebuf[sizeof(ve->name)] = '\0';
>> +		if (namebuf[0] == '\0')
>> +			sprintf(namebuf, "ddf_%d", i);
>> +		for (c = namebuf; c < namebuf + sizeof(ve->name); c++)
>> +			if (isspace(*c))
>> +				*c = '-';
>> +		printf("ARRAY /dev/md/%s container=%s member=%d UUID=%s\n",
>> +		       namebuf, nbuf+5, i, nbuf1+5);
>>  	}
>>  }
>>  
> 

