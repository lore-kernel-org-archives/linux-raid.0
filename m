From: Luca Berra <bluca@comedia.it>
Subject: Re: [mdadm PATCH 1/3] fix gcc warnings about strict-aliasing rules
Date: Tue, 2 Mar 2010 08:48:11 +0100
Message-ID: <20100302074811.GC28827@maude.comedia.it>
References: <20100227135338.GB24207@maude.comedia.it> <4B8CC0E5.4040004@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8CC0E5.4040004@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 02, 2010 at 10:40:21AM +0300, Michael Tokarev wrote:
>Luca Berra wrong:
>> Signed-off-by: Luca Berra <bluca@comedia.it>
>> ---
>>   util.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/util.c b/util.c
>> index 68f048d..1def2a0 100644
>> --- a/util.c
>> +++ b/util.c
>> @@ -1160,7 +1160,7 @@ static int get_gpt_last_partition_end(int fd,
>> unsigned long long *endofpart)
>>       entry_size = __le32_to_cpu(buf[GPT_ENTRY_SIZE_OFFSET]);
>>         /* Check GPT signature*/
>> -    if (*((__u64*)buf) != GPT_SIGNATURE_MAGIC)
>> +    if ((__u64)buf[0] != GPT_SIGNATURE_MAGIC)
>
>This looks wrong.
>
>buf is an array of unsigned char.  Before, we converted the
>whole thing to a pointer to u64 and took the first element
>at that address, u64 size.  Now after the change, we take
>first _byte_ of the array, convert it to u64 (adding leading
>zeros) and compare with a large number.

you are correct, this is obviously wrong, i wonder what i was thinking.

any idea on how to get this right?
sscanf? union?

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
