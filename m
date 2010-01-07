From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Linear mode: array size is less than sum of sizes
Date: Thu, 07 Jan 2010 00:33:12 +0000
Message-ID: <4B452BC8.5030103@anonymous.org.uk>
References: <f4143ac21001051021o45110f1fi833fc03bf9bae4a@mail.gmail.com>	 <4B439BC8.1030908@anonymous.org.uk> <f4143ac21001061414jc5584e3n2015d0e93c2d8d3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4143ac21001061414jc5584e3n2015d0e93c2d8d3c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alessandro Baretta <alexbaretta@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/01/2010 22:14, Alessandro Baretta wrote:
> On Tue, Jan 5, 2010 at 9:06 PM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> [...] If you're going to do this I can't help thinking you should
>> duplicate the real partition table, showing the partition starting on sector
>> 63, so you want 63 extra sectors, not 16002.
[...]
> You were right. No way to get the Windows bootloader to even try
> starting up Windows unless the windows partition is exactly at the
> safe offset from as it is in the original drive.

I had a feeling it might; I think there's another copy of the partition 
description inside the partition somewhere, at least involved in the 
boot process. Not sure though. You may also have problems if you don't 
have the right drivers to match the virtual environment in your Windows 
startup.

Anyway, you could still have a go at concatenating two partitions with 
dmsetup.

Cheers,

John.

