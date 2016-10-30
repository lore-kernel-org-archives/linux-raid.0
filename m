From: TomK <tk@mdevsys.com>
Subject: Re: [ LR] Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more
 than 120 seconds.
Date: Sun, 30 Oct 2016 17:08:46 -0400
Message-ID: <6da81a22-8a07-7e6f-cd93-ddc5a97b2366@mdevsys.com>
References: <73e35e17-80aa-c7e6-535c-3665d9789e16@mdevsys.com>
 <20161030201302.GB6727@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161030201302.GB6727@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/30/2016 4:13 PM, Andreas Klauer wrote:
> On Sun, Oct 30, 2016 at 02:56:58PM -0400, TomK wrote:
>> So the question is how come the mdadm RAID did not catch this disk as a
>> failed disk and pull it out of the array?
>
> RAID doesn't know about SMART. It's that simple.
>
> If SMART already knows about errors - too bad, RAID doesn't care.
> It also doesn't know about anything else really. You ddrescue the
> member disk directly and it finds tons of errors... RAID isn't involved.
>
> RAID will only kick when it by itself stumbles over an error that does
> not go away when rewriting data. Or when the drive just doesn't respond
> anymore for an extended period of time. And that timeout is per request
> so a bad disk can grind the entire system to a halt without ever kicked.
>
> ddrescue has this nice --min-read-rate option, any zone that yields data
> slower will be considered a hopeless case, RAID does not have such magic.
> If your drive always responds and always claims to successfully write
> even when it doesn't, then RAID will never kick it.
>
> If you never run array checks or smart selftests, errors won't show.
> RAID will show them as healthy, SMART will show them as healthy,
> doesn't mean diddly-squat until you actually test it. Regularly.
>
> Kicking drives yourself is quite normal. RAID only does so much.
> This is why we have mdadm --replace, that way even a semi-broken disk
> can help with the rebuild effort and bad sectors on other disks won't
> result in an even bigger problem, or at least, not right away.
>
> If you leave RAID to its own devices, it has a much higher chance of dying
> than if you run tests, and actually decide to do something once *you're*
> aware that there are problems that RAID itself isn't aware of.
>
>> On a separate topic, if I eventually expand the array to 6 2TB disks,
>> will the array be smart enough to allow me to expand it to the new size?
>
> Yes. Perhaps after an additional --grow --size=max.
>
> Regards
> Andreas Klauer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Very clear. Thanks Andreas!

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.

