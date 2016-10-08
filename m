From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: Bitmap in RAM?
Date: Sat, 8 Oct 2016 19:23:04 +0300
Message-ID: <57F91D68.1080708@yandex.ru>
References: <57F8EC82.9010804@yandex.ru> <20161008210216.1a3fead2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161008210216.1a3fead2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If I remove it entirely, I won't be able to re-add drives at all. If I 
move it to a tmpfs, then I can re-add them, but not across reboots - and 
with no downsides, which I want to confirm. So this would be better than 
removing it completely.

I've thought about it and switched the external bitmaps to the 
chunk-size of 65536, which apparently is the default for intermal 
bitmaps. They've become much smaller, which means the default size 
selected for them before was indeed much higher. I'll see if I notice 
any difference the next time I'm moving data around; maybe the load will 
indeed be negligible.


On 08/10/16 19:02, Roman Mamedov wrote:
> On Sat, 8 Oct 2016 15:54:26 +0300
> Dark Penguin <darkpenguin@yandex.ru> wrote:
>
>> So if I were to place it on a tmpfs, I could eliminate this problem only
>> at the expense of being unable to re-add drives after a reboot, right?..
>
> If you don't need that ability, you can just remove bitmap entirely, it's not
> mandatory. Run:
>
>    mdadm --grow --bitmap=none /dev/mdX
>
> However I'd say being able to re-add drives is very useful, so first consider
> switching to a higher bitmap granularity,
>
>    mdadm --grow --bitmap=none /dev/mdX
>    mdadm --grow --bitmap=internal --bitmap-chunk=131072 /dev/mdX
>
> (or even 262144, 524288) as that will reduce the performance impact of the
> bitmap.
>

-- 
darkpenguin
