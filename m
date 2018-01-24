From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: USB-to-SATA and RAID
Date: Tue, 23 Jan 2018 18:40:14 -0600
Message-ID: <ea8286c7-d5de-610a-8bd0-40481dfa2cd4@hardwarefreak.com>
References: <20180123201614.GI23784@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180123201614.GI23784@otheros>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/23/2018 02:16 PM, Linus Lüssing wrote:
> Hi,
>
> By chance I found this statement in the Linux RAID Wiki:
>
> "Do NOT use [USB devices] as part of your array. They have
>   a timeout/disconnect mechanism which interacts very
>   badly with the raid code." [0]
>
> Could someone elaborate further on this? Does "interacts very
> badly" mean that there will be potential data loss / data
> corruption? Or does "very badly" just mean short, temporary
> performance issues / lags upon a disk failure?

Potential data loss / data corruption.  Don't use USB.  Use eSATA 
instead.  The list archives of linux-raid and linux-xfs are dotted with 
USB disk horror stories.

> Regards, Linus
>
> [0]: https://raid.wiki.kernel.org/index.php/Choosing_your_hardware,_and_what_is_a_device%3F#USB_devices
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

