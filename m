From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] mdadm: Send version text to stdout rather than stderr
Date: Wed, 7 Jun 2017 10:11:01 +0800
Message-ID: <4ec799ad-b2d5-db8a-516f-5a8341250ae2@suse.com>
References: <1496735987-10653-1-git-send-email-zlliu@suse.com>
 <877f0od124.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877f0od124.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 06/07/2017 09:44 AM, NeilBrown wrote:
> On Tue, Jun 06 2017, Zhilong Liu wrote:
>
>> This helps with piping to a paper.
> It might help you, but it is an API change and could cause problems for
> others.
>
> Some programs, such as "mount -V", send version info to stdout.
> Others, like "gcc -v", send it to stderr.
> There is no uniform standard, it is best to leave the behavior
> unchanged.
>
> If you need to capture the output use
>     mdadm -V |& ...
> or
>     mdadm -V 2>&1
>
> or similar.

Thanks for your detail explanations. Yes, I just encountered this issue 
in my progress of improving ./mdadm/test script,
the ./mdadm --version always prints to stderr, thus I post this email, 
and I have already used "2>&1" in my test script.

Thanks very much,
-Zhilong

> NeilBrtown
>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>>   mdadm.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mdadm.c b/mdadm.c
>> index 70b16f2..0f736d7 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -139,7 +139,7 @@ int main(int argc, char *argv[])
>>   			continue;
>>   
>>   		case 'V':
>> -			fputs(Version, stderr);
>> +			fputs(Version, stdout);
>>   			exit(0);
>>   
>>   		case 'v': c.verbose++;
>> -- 
>> 2.6.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

