From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid array is not automatically detected.
Date: Wed, 18 Jul 2007 04:06:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707180406320.2902@p34.internal.lan>
References: <4697E231.3070906@hp.com> <4698D4FC.2060100@tmr.com>
 <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan> <469B7E75.3030907@hp.com>
 <469B8D05.1080003@dgreaves.com> <Pine.LNX.4.64.0707172227490.16002@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707172227490.16002@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: David Greaves <david@dgreaves.com>, Bryan Christ <bryan.christ@hp.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 17 Jul 2007, dean gaudet wrote:

>
>
> On Mon, 16 Jul 2007, David Greaves wrote:
>
>> Bryan Christ wrote:
>>> I do have the type set to 0xfd.  Others have said that auto-assemble only
>>> works on RAID 0 and 1, but just as Justin mentioned, I too have another box
>>> with RAID5 that gets auto assembled by the kernel (also no initrd).  I
>>> expected the same behavior when I built this array--again using mdadm
>>> instead of raidtools.
>>
>> Any md arrays with partition type 0xfd using a 0.9 superblock should be
>> auto-assembled by a standard kernel.
>
> no... debian (and probably ubuntu) do not build md into the kernel, they
> build it as a module, and the module does not auto-detect 0xfd.  i don't
> know anything about slackware, but i just felt it worth commenting that "a
> standard kernel" is not really descriptive enough.
>
> -dean
>

You're correct-- however, I build out my own kernel.

Justin.
