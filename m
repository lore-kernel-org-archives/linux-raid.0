From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mdadm --fail requires writeable drive.
Date: Fri, 15 Nov 2013 12:22:28 +0000
Message-ID: <52861204.5050001@mpstor.com>
References: <52836DD1.8080605@mpstor.com> <20131114114449.27f3c746@notabene.brown> <5285094D.9070904@mpstor.com> <20131115154627.14364eb3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131115154627.14364eb3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/11/13 04:46, NeilBrown wrote:
> On Thu, 14 Nov 2013 17:33:01 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:
>
>> Hi Neil,
>>
>> This does work but I was looking for a way to explicitely set a
>> particular device as Failed (I want to process devices one by one).
>>
>> But right now I was reading from the array to force it detecting the
>> failure as opposed to using "detached" which orders of magnitude better.
>>
>> Thanks for the tip, I'll use that for now.
>

Hi Neil,

> If you really want to just fail one of them you can used the "kernel name"
> like "sda1".
> If you
>     ls -d /sys/block/mdXX/md/dev-*
>

Thanks a lot for this! This is exactly what I was looking for and it 
worked like a charm.

> you will see the devices that are though to be part of the array.  The part
> of the name after "dev-" is the "kernel name".
> "mdadm /dev/mdXX --fail" will accept a "kernel name" and will mark just that
> device as faulty.
>

That's perfect. Thanks a lot!

> NeilBrown
>

Ben.
