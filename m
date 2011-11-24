From: Gavin Whitehead <gavin@alabastercranium.demon.co.uk>
Subject: Re: partition based raid1 and multi boot Ubuntu/Xubuntu
Date: Thu, 24 Nov 2011 13:16:28 +0000
Message-ID: <4ECE43AC.8070907@alabastercranium.demon.co.uk>
References: <4ECC20C4.6050504@alabastercranium.demon.co.uk> <alpine.DEB.2.00.1111241105300.17642@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1111241105300.17642@unicorn.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/11/2011 11:54, Gordon Henderson wrote:
> On Tue, 22 Nov 2011, Gavin Whitehead wrote:
>
>> I then installed Ubuntu 11.04 from the Alternate CD and created some 
>> raid1 devices
>>    md0        sda1 sdb1    /
>>    md1        sda5 sdb5    swap
>>    md2        sda6 sdb6    /home
>
> Can't help you with the GRUB issue as I use LILO, however... Something 
> that someone on this list suggested to me many year back has stuck 
> with me and proven to be useful and that's to try to number the md 
> devices the same as the sd (or hd in those days!) devices, so:
>
> md1 : active raid1  sdb1[1] sda1[0]
> md2 : active raid10 sdb2[1] sda2[0]
> md3 : active raid10 sdb3[1] sda3[0]
> md5 : active raid10 sdb5[1] sda5[0]
>
> etc.
>
> Is it still a good idea? I think so - anything that helps to reduce 
> the possibility of mistakes is good in my books...
>
> Gordon
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Gordon,

Thanks for the suggestion.  I will bear it in mind next time I am 
building the raid devices (which I have a feeling will be soon).

Gav
