From: David Brown <david.brown@hesbynett.no>
Subject: Re: The chunk size paradox
Date: Tue, 31 Dec 2013 14:51:25 +0100
Message-ID: <52C2CBDD.6040207@hesbynett.no>
References: <52C1C01A.7010407@ubuntu.com> <21186.996.238486.690328@tree.ty.sabi.co.uk> <20131231000132.879A7381435@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131231000132.879A7381435@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/12/13 01:01, Wolfgang Denk wrote:
> Dear Peter,
>
> In message <21186.996.238486.690328@tree.ty.sabi.co.uk> you wrote:
>>
>> Therefore a larger chunk size increases the amount of data that
>> can be fetched on each device without waiting for the other
>> device to get to the desires angular position. It has of course
>> the advnatage that you mention, but also the advantage that
>> random IO might be improved.
>
> Hm... does it make sense to discuss any of this without considering
> the actual work load of the storage system?
>
> For example, we have some RAID 6 arrays that store mostly source code
> and the resulting object files when compiling that code.  In this
> environment, we have the following distribution of file sizes:
>
> 	65% 	are smaller than 4 kB
> 	80% 	are smaller than 8 kB
> 	90% 	are smaller than 16 kB
> 	96% 	are smaller than 32 kB
> 	98.4% 	are smaller than 64 kB
>
> It appears to me, that your argumentation is valid only for large (or
> rather huge), strictly sequential file accesses only.  Random acces to
> a large number of small files like in the environment shown above will
> need pretty much different settings for optimal performance.
>
> I think we should not conceal such dependencies.  There is no "one
> size fits all" solution.
>
> Just my $ 0.02.
>
> Best regards,
>
> Wolfgang Denk
>

While that's true, it would be my guess that for most large raid 6 
arrays, there /are/ many large files.  It takes a great many small files 
to justify having raid 6 rather than raid 1, but you don't need too many 
large media files.

But it's important that new options are optional - we don't want to 
reduce performance for existing users, even if it is for less common usage.

