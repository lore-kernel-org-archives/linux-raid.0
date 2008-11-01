From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Linux RAID & XFS Question - Multiple levels of concurrency =
 faster I/O on md/RAID 5?
Date: Sat, 1 Nov 2008 08:00:34 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0811010758240.1053@p34.internal.lan>
References: <alpine.DEB.1.10.0811010424270.16517@p34.internal.lan> <490C359F.7080504@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490C359F.7080504@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Sat, 1 Nov 2008, John Robinson wrote:

> On 01/11/2008 08:29, Justin Piszcz wrote:
> [...]
>> Why is running 3 jobs con-currently that take care of two parts each more 
>> than
>> twice as fast than running one job for six parts?
>
> Because you have multiple CPUs?

So 1/4 of a quad core q6600 cannot achieve higher rates of I/O due to the
parity operations being that costly?

Is the only way to increase the single-threaded speed to increase the maximum
CPU core speed/get a faster CPU, and/or theoretically a multi-threaded md-raid
could maximize throughput?

Justin.


