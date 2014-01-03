From: Joe Landman <joe.landman@gmail.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 22:14:41 -0500
Message-ID: <52C62B21.2090609@gmail.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5BC28.2020003@gmail.com> <52C5EB62.1090807@hardwarefreak.com> <52C5EE8F.3090204@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5EE8F.3090204@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, stan@hardwarefreak.com
Cc: Phillip Susi <psusi@ubuntu.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/02/2014 05:56 PM, Carsten Aulbert wrote:
> Hi
>
> sorry late in joining the thread

Hey Carsten, good to see you here!

>
> On 01/02/2014 11:42 PM, Stan Hoeppner wrote:
>>
>> Damn, you had me salivating Joe.  These are both AF 512e drives, not
>> native 4K.
>>
>>> and many others.
>>
>> I've not yet seen an announcement from anyone.  I'm not all seeing, but
>> I'd think such an announcement would cross my RADAR.
>>
>
> Just look around:
>
>
> http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771475.pdf
>
> and then the FAQ about "Advanced Format":
>
> https://wdc.custhelp.com/app/answers/detail/a_id/5655
>
> Why would one need to align to 4k if the on disk layout would be 512bytes?
>
> Or did I miss something?

If you align to a 1k size (2x 512 byte emulated sectors), then you will 
be offset from the start of the real 4k sector.  As you can see from the 
WD document, advanced format drives are 4k with a 512byte translation 
layer.  They are there specifically to provide backwards compatibility 
for old OSes.  For best performance, they recommend using the units in 
their native 4k format.

But they are 4k native and you can use them that way.   The 512 byte 
layer is emulated.


