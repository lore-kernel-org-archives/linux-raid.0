From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] md/raid6: use faster multiplication for ARM NEON
 delta syndrome
Date: Thu, 13 Jul 2017 19:00:12 +0100
Message-ID: <CAKv+Gu865hPJZ=7L8dQgN1coALhb3+6rY7HGbd=bRisK7W6yWw@mail.gmail.com>
References: <20170713171601.25440-1-ard.biesheuvel@linaro.org>
 <20170713171601.25440-2-ard.biesheuvel@linaro.org> <12EF8D94C6F8734FB2FF37B9FBEDD173010E029C61@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173010E029C61@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "shli@kernel.org" <shli@kernel.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "will.deacon@arm.com" <will.deacon@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>
List-Id: linux-raid.ids

On 13 July 2017 at 18:51, Markus Stockhausen <stockhausen@collogia.de> wrote:
>> Von: Ard Biesheuvel [ard.biesheuvel@linaro.org]
>> Gesendet: Donnerstag, 13. Juli 2017 19:16
>> An: linux-arm-kernel@lists.infradead.org; linux-raid@vger.kernel.org
>> Cc: shli@kernel.org; Markus Stockhausen; linux@armlinux.org.uk; will.deacon@arm.com; catalin.marinas@arm.com; Ard Biesheuvel
>> Betreff: [PATCH 1/2] md/raid6: use faster multiplication for ARM NEON delta syndrome
>>
>> The P/Q left side optimization in the delta syndrome simply involves
>> repeatedly multiplying a value by polynomial 'x' in GF(2^8). Given
>> that 'x * x * x * x' equals 'x^4' even in the polynomial world, we
>> can accelerate this substantially by performing up to 4 such operations
>> at once, using the NEON instructions for polynomial multiplication.
>>
>> Results on a Cortex-A57 running in 64-bit mode:
>>
>>   Before:
>>   -------
>>   raid6: neonx1   xor()  1680 MB/s
>>   raid6: neonx2   xor()  2286 MB/s
>>   raid6: neonx4   xor()  3162 MB/s
>>   raid6: neonx8   xor()  3389 MB/s
>>
>>   After:
>>   ------
>>   raid6: neonx1   xor()  2281 MB/s
>>   raid6: neonx2   xor()  3362 MB/s
>>   raid6: neonx4   xor()  3787 MB/s
>>   raid6: neonx8   xor()  4239 MB/s
>
> Nice optimiziation. Nevertheless the test algorithm favours this implementation. See:
>
> int start = (disks>>1)-1, stop = disks-3; /* work on the second half of the disks */
>
> What gives the before/after test if you work on the middle data disks and not on
> the right ones? In the 4K page size this should be  start = 3, stop = 11 instead of
> start = 7, stop = 13. Given the large gain you see the impact should be lower but
> at least in the >10% range.
>

Relative before and after (using raid6test rather than the kernel
module this time, so they should not be compared with the numbers
above)

before
raid6: neonx1   xor()  1773 MB/s
raid6: neonx2   xor()  2362 MB/s
raid6: neonx4   xor()  3223 MB/s
raid6: neonx8   xor()  3375 MB/s

after
raid6: neonx1   xor()  2259 MB/s
raid6: neonx2   xor()  2975 MB/s
raid6: neonx4   xor()  3404 MB/s
raid6: neonx8   xor()  3788 MB/s

So your estimate is correct: 12% speedup for neonx8 in the 'start = 7,
stop = 13' case

-- 
Ard.
