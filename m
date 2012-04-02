From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Linux 3.3.1 resync speed
Date: Mon, 2 Apr 2012 22:30:55 +0100
Message-ID: <CADNH=7FmLV8QhNqTCiPapNWxGxpa_yys=33wewtf3hydHUyw2Q@mail.gmail.com>
References: <CADNH=7H3ejuJSLymMoxiFtnY90Ur5_e8D71UK5eDWqXRX1-oHQ@mail.gmail.com>
	<4F7A19E1.4050102@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7A19E1.4050102@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2 April 2012 22:28, Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
> This is a known issue and a patch has been submitted. I'm not sure when
> it is scheduled to appear in the kernel.
>
> There will be no actual disk I/O during the raid check and the array
> will not actually be checked.
>
> --Larkin
>

Ok, thanks for letting me know. I thought it looked too good to be
true. I'm actually observing this on 3.3.0, not 3.3.1 as I originally
reported.

Mathias
