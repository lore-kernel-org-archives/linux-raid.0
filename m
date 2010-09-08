From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 3-way mirrors
Date: Wed, 08 Sep 2010 18:28:19 -0400
Message-ID: <4C880E03.3080109@tmr.com>
References: <20100907190255.15094.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907190255.15094.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: Simetrical+list@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

George Spelvin wrote:
>> This might be useful reading:
>>
>> http://neil.brown.name/blog/20100211050355
>>     
>
> An interesting point of view, BUT...
>
> If I am seeing repeated unexplained mismatches (despite being on a good
> UPS and having no unclean shutdowns), then some part of my hardware is
> failing, and I'd like to know *what part*.
>   

How about your disk enclosure? I would think that if vibration caused a 
silent bit flip *on write* you would get a read error (CRC) reading it 
back. but... I am going on the theory that any factor which causes 
measurable errors on read is not doing anything good for writes either.

See: http://www.zdnet.com/blog/storage/bad-bad-bad-vibrations/896

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

