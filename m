From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: The chunk size paradox
Date: Fri, 03 Jan 2014 14:51:10 +0000
Message-ID: <52C6CE5E.50400@mpstor.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <20140102223246.8DBE538220E@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140102223246.8DBE538220E@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>, stan@hardwarefreak.com
Cc: Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/14 22:32, Wolfgang Denk wrote:
> Dear Stan,
>
> In message <52C5A9AA.9090300@hardwarefreak.com> you wrote:
>>
>>> filesystem blocks and memory pages aren't necessarily 4K, though that
>>> is the most common size.
>>
>> Yes, they are necessarily 4K in Linux.  Linux only supports page sized
>> BIO for consistency across the memory manager and IO subsystems.  Most
>> architectures which Linux currently supports have hardware page sizes
>> greater than 4K, for instance IA64 supports 4k/8k/16k, even a 4GB page
>> size.  But it was decided long ago to stick with 4K for a number of
>> reasons, one of these is stated above.  For background on this Google is
>> your friend.
>
> Well, you can tune the page size - and if you need no file system
> support (like when implementing a RAID controller card) making the
> page size exactly the same as the chunk size will allow for some nice
> performance optimizations (as you can avoid a lot of large memcpy()
> operations).
>
> We did this (some 6 years ago) for the (then AMCC) PPC440SPe
> processors; I can't find the old document any longer on APM's web
> site, but there is still a copy here ([1]) which shows the effect.
>
I had the chance to work with those AMCC boards and I confirm that 
aligning the chunk size on the (larger) PPC440 page size yielded some 
impressive performance results. We were topping the hardware 
capabilities. On the other hand, the entire kernel was built for this 
particular hardware and I'm not sure how well tuning the system page 
size would work on an Intel platform.

> So yes, tuning the system page size can have considerable impact, but
> only for special-purpose applications, and when optimising for large
> sequential I/O (which appears to be how the RAID controller
> manufacturers are testing / optimizing their systems).
>
>
> Fact is, with a file system on top of the RAID array, and with our
> typical work load of many very small files, A RAID6 with chunk size
> 16k will give much better results that with chunk size 64k - and
> anything even bigger will be worse.
>
>
> [1] ftp://ftp.denx.de/pub/demos/RAID-demo/doc/RAIDinLinux_PB_0529a.pdf
>
> Best regards,
>
> Wolfgang Denk
>
Regards,
Ben.
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> "The first rule of magic is simple. Don't waste your time waving your
> hands and hoping when a rock or a club will do."
>                                                 - McCloctnik the Lucid
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

