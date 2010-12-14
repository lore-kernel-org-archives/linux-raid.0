From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Debugging a strange array corruption
Date: Tue, 14 Dec 2010 18:29:31 +0800
Message-ID: <4D07470B.4060601@wasp.net.au>
References: <4D07265F.8060109@wasp.net.au>	<20101214142246.20c927e1@natsu>	<4D073AF1.7090709@wasp.net.au> <20101214144231.0493d534@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101214144231.0493d534@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/12/10 17:42, Roman Mamedov wrote:
> On Tue, 14 Dec 2010 17:37:53 +0800
> Brad Campbell<brad@wasp.net.au>  wrote:
>
>> And in the prior incarnation I was only using 1 port on that controller so
>> the problem would never have manifested itself. Thanks, at least I have
>> something to try.
>
> To add another idea to my previous reply, it should be pretty easy to test for
> the presence of this particular problem by running your dd+md5sum test on just
> the two physical disks which are plugged into that controller, starting the
> tests simultaneously on both disks (in two terminal windows). See if you get
> varying sums over several runs that way.

I just finished that test. Can I cry now?

Thanks Roman, I'd *never* have pegged it otherwise.

Anyone want a slightly second hand SIL 2 port controller?

Regards,
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
