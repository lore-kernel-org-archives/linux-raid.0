From: David Brown <david.brown@hesbynett.no>
Subject: Re: question about the best suited RAID level/layout
Date: Sun, 07 Jul 2013 16:08:17 +0200
Message-ID: <51D97651.8060704@hesbynett.no>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D61D71.5090406@hardwarefreak.com>  <1373071585.5395.45.camel@fermat.scientia.net>  <51D7D72B.4070401@hardwarefreak.com> <1373123051.5217.19.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373123051.5217.19.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/07/13 17:04, Christoph Anton Mitterer wrote:
> On Sat, 2013-07-06 at 03:36 -0500, Stan Hoeppner wrote:
>>>> hot/warm/cold spares in the chassis.
>>>>    This simply degrades performance.
>>> Why should it? If the spare is unused?
>> The answer is rather obvious.  If spares are in the chassis one has
>> fewer active array spindles.
> Sorry... still don't get it...
> When you have another drive in the chassis... which is not actively used
> by the RAID, but just waiting as a hot spare for a failing device and
> rebuild becoming necessary...
> Apart from power consumption and more heat... how should that affect the
> read/write performance of the RAID?
>

I think the point is that you have a slot in your chassis that is not 
being used actively.  If you have five disk bays, then you will get 
better performance with 5 disks in your array and a spare on the shelf 
beside it than with 4 disks in the array and a spare in the chassis.


