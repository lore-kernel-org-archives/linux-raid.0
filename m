From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: some general questions on RAID
Date: Fri, 05 Jul 2013 11:06:43 +0800
Message-ID: <51D63843.50306@fnarfbargle.com>
References: <CDFB4726.1374F%sam@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CDFB4726.1374F%sam@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/07/13 09:39, Sam Bingner wrote:
> On 7/4/13 3:13 PM, "Brad Campbell" <lists2009@fnarfbargle.com> wrote:
>
>> On 05/07/13 02:30, Christoph Anton Mitterer wrote:

>> When I say max out, I run into bandwidth limits on the hardware before
>> dmcrypt gets in the way.
>>
>
> That is because your CPU has encryption features - the QNAP devices
> largely do not; I replaced the CPU in mine with one that had encryption
> features because otherwise there was nothing that could bring the
> performance above about 80MB/sec
>
>
> Once I put in a CPU supporting AESNI I could get up to about 500MB/sec -
> and this was still not CPU bound

Yes, of course. I forgot about the dedicated storage device rather than 
a general server. I run dmcrypt on a WD mybook live and get about 8MB/s 
on that (which is enough for what I need).

