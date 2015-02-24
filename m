From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/5] Check return of stat() to avoid covscan complaining
Date: Tue, 24 Feb 2015 16:56:29 -0500
Message-ID: <wrfj61ar55yq.fsf@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
	<1424811640-26569-3-git-send-email-Jes.Sorensen@redhat.com>
	<20150225081243.1fe91420@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150225081243.1fe91420@notabene.brown> (NeilBrown's message of
	"Wed, 25 Feb 2015 08:12:43 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Tue, 24 Feb 2015 16:00:37 -0500 Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  Assemble.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Assemble.c b/Assemble.c
>> index 131f871..b392214 100644
>> --- a/Assemble.c
>> +++ b/Assemble.c
>> @@ -688,7 +688,11 @@ static int load_devices(struct devs *devices, char *devmap,
>>  			close(dfd);
>>  		}
>>  
>> -		stat(devname, &stb);
>> +		if (stat(devname, &stb)) {
>> +			pr_err("Unsable to stat(%s) - skipping device.\n",
>> +			       devname);
>> +			continue;
>> +		}
>>  
>>  		if (c->verbose > 0)
>>  			pr_err("%s is identified as a member of %s, slot %d%s.\n",
>
> I've applied the other 4.  I think I'd rather this one was fixed by changing
>   stat(devname,
> to
>   fstat(dfd,
> and keep dfd open a bit longer.
>
> Does this look OK to you?

I got the warning from covscan because we ignored the return value from
stat, so I think you still need to check the return value from fstat()
as well.

Cheers,
Jes

>
> Thanks,
> NeilBrown
>
> diff --git a/Assemble.c b/Assemble.c
> index 131f871a6d1e..1e529c1b3126 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -576,13 +576,13 @@ static int load_devices(struct devs *devices, char *devmap,
>  		struct stat stb;
>  		struct supertype *tst;
>  		int i;
> +		int dfd;
>  
>  		if (tmpdev->used != 1)
>  			continue;
>  		/* looks like a good enough match to update the super block if needed */
>  #ifndef MDASSEMBLE
>  		if (c->update) {
> -			int dfd;
>  			/* prepare useful information in info structures */
>  			struct stat stb2;
>  			int err;
> @@ -652,7 +652,6 @@ static int load_devices(struct devs *devices, char *devmap,
>  			if (tst->ss->store_super(tst, dfd))
>  				pr_err("Could not re-write superblock on %s.\n",
>  				       devname);
> -			close(dfd);
>  
>  			if (strcmp(c->update, "uuid")==0 &&
>  			    ident->bitmap_fd >= 0 && !bitmap_done) {
> @@ -666,9 +665,9 @@ static int load_devices(struct devs *devices, char *devmap,
>  		} else
>  #endif
>  		{
> -			int dfd = dev_open(devname,
> -					   tmpdev->disposition == 'I'
> -					   ? O_RDWR : (O_RDWR|O_EXCL));
> +			dfd = dev_open(devname,
> +				       tmpdev->disposition == 'I'
> +				       ? O_RDWR : (O_RDWR|O_EXCL));
>  			tst = dup_super(st);
>  
>  			if (dfd < 0 || tst->ss->load_super(tst, dfd, NULL) != 0) {
> @@ -685,10 +684,10 @@ static int load_devices(struct devs *devices, char *devmap,
>  				return -1;
>  			}
>  			tst->ss->getinfo_super(tst, content, devmap + devcnt * content->array.raid_disks);
> -			close(dfd);
>  		}
>  
> -		stat(devname, &stb);
> +		fstat(dfd, &stb);
> +		close(dfd);
>  
>  		if (c->verbose > 0)
>  			pr_err("%s is identified as a member of %s, slot %d%s.\n",
