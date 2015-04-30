From: Guoqing Jiang <jgq516@gmail.com>
Subject: Re: [PATCH 08/10] mdadm: add the ability to change cluster name
Date: Thu, 30 Apr 2015 11:22:15 +0800
Message-ID: <55419FE7.1030507@gmail.com>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>	<1429860641-5839-9-git-send-email-gqjiang@suse.com> <20150429115033.1191a357@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150429115033.1191a357@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: gqjiang@suse.com, linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, 24 Apr 2015 15:30:39 +0800 gqjiang@suse.com wrote:
>
>   
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -1073,6 +1073,25 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  		info->name[32] = 0;
>>  	}
>>  
>> +	if (strcmp(update, "home-cluster") == 0 &&
>> +	    homehost) {
>> +		/* Note that 'home-cluster' is to change the name of cluster,
>> +		 * it is another "name" update.
>> +		 */
>> +		char *new_name = xmalloc(sizeof(sb->set_name));
>> +		if (strrchr(sb->set_name, ':')) {
>> +			strcpy(new_name, strchr(sb->set_name, ':'));
>> +		}
>> +
>> +		memset(sb->set_name, 0, sizeof(sb->set_name));
>> +		strcpy(sb->set_name, homehost);
>> +		if (new_name)
>> +			strcat(sb->set_name, new_name);
>> +
>> +		free(new_name);
>> +		goto out;
>> +	}
>> +
>>     
>
> Please get rid of the 'goto out' and put an 'else' in here.
>
> "homehost" is special because it translates to "name".
> "home-cluster" is not special.
>
>   
Got it.
>   
>>  	if (strcmp(update, "force-one")==0) {
>>  		/* Not enough devices for a working array,
>>  		 * so bring this one up-to-date
>> @@ -1313,6 +1332,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  	else
>>  		rv = -1;
>>  
>> +out:
>>  	sb->sb_csum = calc_sb_1_csum(sb);
>>  	return rv;
>>  }
>> @@ -1691,7 +1711,7 @@ static int write_init_super1(struct supertype *st)
>>  		sb->sb_csum = calc_sb_1_csum(sb);
>>  		rv = store_super1(st, di->fd);
>>  		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
>> -			rv = st->ss->write_bitmap(st, di->fd);
>> +			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
>>  		close(di->fd);
>>  		di->fd = -1;
>>  		if (rv)
>> @@ -2175,7 +2195,7 @@ static void locate_bitmap1(struct supertype *st, int fd)
>>  	lseek64(fd, offset<<9, 0);
>>  }
>>  
>> -static int write_bitmap1(struct supertype *st, int fd)
>> +static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update)
>>  {
>>  	struct mdp_superblock_1 *sb = st->sb;
>>  	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb)+MAX_SB_SIZE);
>> @@ -2185,6 +2205,28 @@ static int write_bitmap1(struct supertype *st, int fd)
>>  	struct align_fd afd;
>>  	unsigned int i;
>>  
>> +	switch (update) {
>> +	case NameUpdate:
>> +	{
>> +	    char *new_name = xmalloc(sizeof(sb->set_name));
>> +
>> +	    strncpy(new_name, sb->set_name, sizeof(sb->set_name));
>> +	    memset((char *)bms->cluster_name, 0, sizeof(bms->cluster_name));
>> +
>> +	    if (strtok(new_name, ":"))
>> +		strncpy((char *)bms->cluster_name, new_name, strlen(sb->set_name));
>> +	    else
>> +		/* In case the original set_name doesn't like aaa:md* */
>> +		strncpy((char *)bms->cluster_name, sb->set_name, strlen(sb->set_name));
>> +
>> +	    free(new_name);
>> +	    break;
>> +	}
>>     
>
> I don't like the braces there - too confusing.
> Just make 'new_name' a top-level variable and get rid of the {}
>
>   
No problem, will do it.

Thanks,
Guoqing
