From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 3/4] Add --initrd argument to mdmon
Date: Mon, 23 Jan 2012 11:27:11 +0100
Message-ID: <4F1D35FF.1070301@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>	<1326797330-4488-4-git-send-email-Jes.Sorensen@redhat.com> <20120122222204.3156a3a7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120122222204.3156a3a7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

On 01/22/12 12:22, NeilBrown wrote:
> On Tue, 17 Jan 2012 11:48:49 +0100 Jes.Sorensen@redhat.com wrote:
> 
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  mdmon.c |   13 +++++++++++++
>>  1 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/mdmon.c b/mdmon.c
>> index a65c4a4..139bd85 100644
>> --- a/mdmon.c
>> +++ b/mdmon.c
>> @@ -276,6 +276,12 @@ void usage(void)
>>  	exit(2);
>>  }
>>  
>> +/*
>> + * Option values that don't have a short version, to avoid clashing\
>> + * with ascii values
> 
> The purpose of the trailing slosh (back slash) is ....?

It was there to see if you were awake :) .... or because someone didn't
see what he was doing.

>> + */
>> +#define INITRD_OPT	0x100
> 
> Can we make this an enum just like in mdadm??

Sure - I will keep the value though, to avoid clashing with ascii.

>> +
>>  static int mdmon(char *devname, int devnum, int must_fork, int takeover);
>>  
>>  int main(int argc, char *argv[])
>> @@ -283,6 +289,7 @@ int main(int argc, char *argv[])
>>  	char *container_name = NULL;
>>  	int devnum;
>>  	char *devname;
>> +	char *c;
>>  	int status = 0;
>>  	int opt;
>>  	int all = 0;
>> @@ -291,6 +298,7 @@ int main(int argc, char *argv[])
>>  		{"all", 0, NULL, 'a'},
>>  		{"takeover", 0, NULL, 't'},
>>  		{"help", 0, NULL, 'h'},
>> +		{"initrd", 0, NULL, INITRD_OPT},
>>  		{NULL, 0, NULL, 0}
>>  	};
>>  
>> @@ -304,6 +312,11 @@ int main(int argc, char *argv[])
>>  			container_name = optarg;
>>  			takeover = 1;
>>  			break;
>> +		case INITRD_OPT:
>> +			c = argv[0];
>> +			c[0] = '@';
>> +			continue;
> 
> And can we use
>                         argv[0][0] = '@';
> 
> here too?

Sure

> Otherwise looks good.

Thanks, I'll update and also do the help message + man-page stuff. v2
coming up shortly.

Cheers,
Jes
