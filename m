From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH 1/2] lib/raid6: Build proper files on corresponding arch
Date: Wed, 12 Apr 2017 19:27:12 +1000
Message-ID: <87inmakmbz.fsf@possimpible.ozlabs.ibm.com>
References: <20170412013552.21650-1-matthew.brown.dev@gmail.com> <87wpaqt8ia.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wpaqt8ia.fsf@concordia.ellerman.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, Matt Brown <matthew.brown.dev@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Ellerman <mpe@ellerman.id.au> writes:

> Matt Brown <matthew.brown.dev@gmail.com> writes:
>
>> diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
>> index 9c333e9..62b26d1 100644
>> --- a/lib/raid6/test/Makefile
>> +++ b/lib/raid6/test/Makefile
>> @@ -44,10 +44,12 @@ else ifeq ($(HAS_NEON),yes)
>>          CFLAGS += -DCONFIG_KERNEL_MODE_NEON=1
>>  else
>>          HAS_ALTIVEC := $(shell printf '\#include <altivec.h>\nvector int a;\n' |\
>> -                         gcc -c -x c - >&/dev/null && \
>> -                         rm ./-.o && echo yes)
>> +			 gcc -c -x c - >/dev/null && rm ./-.o && echo yes)
>>          ifeq ($(HAS_ALTIVEC),yes)
>> -                OBJS += altivec1.o altivec2.o altivec4.o altivec8.o
>> +		CFLAGS += -I../../../arch/powerpc/include
>> +		CFLAGS += -DCONFIG_ALTIVEC
>> +		OBJS += altivec1.o altivec2.o altivec4.o altivec8.o \
>> +			vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
>
> The whitespace in here is a bit of a mess, but you should follow what's
> there and use spaces to indent your additions.

My apologies for steering you in the wrong direction here Matt!

Also, should the changes to altivec.uc in patch 2 be part of this patch?
From memory they are also needed to run the tests?

Regards,
Daniel
>
> cheers
