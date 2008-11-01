From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency =
 faster I/O on md/RAID 5?
Date: Sat, 01 Nov 2008 12:14:44 +0000
Message-ID: <490C4834.3050404@anonymous.org.uk>
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan> <490C359F.7080504@anonymous.org.uk> <alpine.DEB.1.10.0811010758240.1053@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811010758240.1053@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On 01/11/2008 12:00, Justin Piszcz wrote:
> On Sat, 1 Nov 2008, John Robinson wrote:
>> On 01/11/2008 08:29, Justin Piszcz wrote:
>> [...]
>>> Why is running 3 jobs con-currently that take care of two parts each 
>>> more than
>>> twice as fast than running one job for six parts?
>>
>> Because you have multiple CPUs?
> 
> So 1/4 of a quad core q6600 cannot achieve higher rates of I/O due to the
> parity operations being that costly?
> 
> Is the only way to increase the single-threaded speed to increase the 
> maximum
> CPU core speed/get a faster CPU, and/or theoretically a multi-threaded 
> md-raid
> could maximize throughput?

Actually I was thinking that your test job - I think you said it used 
tar - is single-threaded and CPU-bound on one core, and doesn't saturate 
the MD subsystem. Your jobs are 75% user time to 25% system time, and 
the user time is not parellelisable until you do it yourself by 
splitting the work up.

Cheers,

John.

