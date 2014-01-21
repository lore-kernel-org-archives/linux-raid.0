From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] Allow to check mdadm with clangs static checker (scan-build)
Date: Tue, 21 Jan 2014 18:39:56 +0100
Message-ID: <52DEB0EC.5070103@fastmail.fm>
References: <52DD4B54.4060809@fastmail.fm> <20140121100643.0ebaf13d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121100643.0ebaf13d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/21/2014 12:06 AM, NeilBrown wrote:
> On Mon, 20 Jan 2014 17:14:12 +0100 Bernd Schubert
> <bernd.schubert@fastmail.fm> wrote:
>
>> Clangs scan-build tool (static checker) set the environmental variable CC,
>> so Makefile should allow to use that value.
>>
>> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>> ---
>>   Makefile |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 043bcea..63cc3ac 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -41,7 +41,7 @@ KLIBC=/home/src/klibc/klibc-0.77
>>
>>   KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32
>>
>> -CC = $(CROSS_COMPILE)gcc
>> +CC ?= $(CROSS_COMPILE)gcc
>>   CXFLAGS ?= -ggdb
>>   CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>>   ifdef WARN_UNUSED
>
> I'm not exactly against this, but presumably you could tell scan-build to run
>
>    make CC=$CC
>
> to achieve the same effect with no patch ??
>
> i.e.
>
>    scan-build 'make CC=$CC'

Yeah, that would also work. IMHO, it is just not very intuitive.
Maybe I should submit a patch for the man page of the debian package and 
upstream docs.

>
> But maybe I'll apply it anyway.

Would be great.


Thanks,
Bernd
