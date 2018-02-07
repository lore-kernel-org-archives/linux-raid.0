From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: [OT] C programming problem
Date: Wed, 7 Feb 2018 20:22:01 +0000
Message-ID: <7b976e5c-cb0a-ded2-e812-fd3cdddfe864@youngman.org.uk>
References: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
 <46a82977-bb58-8ac5-bbde-ba027339f31e@fritscher.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46a82977-bb58-8ac5-bbde-ba027339f31e@fritscher.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Michael Fritscher <michael@fritscher.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/18 20:00, Michael Fritscher wrote:
> Hello,
> 
>> main.c:20:5: warning: incompatible implicit declaration of built-in
>> function ‘memset’ [enabled by default]
>>      memset( &array, 0, blocks * sizeof(int) );
> 
> at least my compiler says something about
>> a.c:21:5: note: include ‘<string.h>’ or provide a declaration of ‘memset’
> 
> And yes, the first recipe does indeed help :-P
> 
Thank you both! Perfect!

I think actually stdlib had fixed the malloc problem, but I missed it 
because the memset problem was still there.

Cheers,
Wol
