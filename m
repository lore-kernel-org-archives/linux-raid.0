From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 3/8] Grow: Grow_continue_command() remove dead code
Date: Wed, 09 Mar 2016 11:19:26 -0500
Message-ID: <wrfjio0vvd2p.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<1457458252-20203-4-git-send-email-Jes.Sorensen@redhat.com>
	<87fuw0lhhf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fuw0lhhf.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Wed, 09 Mar 2016 09:42:04 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> All cases where fd2 is used are completed with a close(fd2) ; fd2 = -1;
>> so there is no need to check for fd2 > -1 before exiting.
>
> In that case, you can remove all the assignments so -1 to fd2 - if you
> like.

Oh good point - I'll make that change.

Thanks,
Jes

>
> Thanks,
> NeilBrown
>
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  Grow.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/Grow.c b/Grow.c
>> index c4f417e..0fa776d 100755
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -4924,8 +4924,6 @@ int Grow_continue_command(char *devname, int fd,
>>  	ret_val = Grow_continue(fd, st, content, backup_file, 1, 0);
>>  
>>  Grow_continue_command_exit:
>> -	if (fd2 > -1)
>> -		close(fd2);
>>  	if (cfd > -1)
>>  		close(cfd);
>>  	st->ss->free_super(st);
>> -- 
>> 2.5.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
