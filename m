From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Mon, 18 Jan 2016 14:09:03 -0500
Message-ID: <569D384F.6070208@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
 <56429326.5030405@turmel.org>
 <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
 <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi Mathias,

On 01/18/2016 10:33 AM, Mathias Mueller wrote:
> Hi Phil,
> 
> first thanks a lot for all your help and time you already spent on me
> and my problem. I gathered some more information and hope you can help
> me a bit more.

You're welcome.

> First I  tried to figure out the chunk size. I used a jpg file that was
> stored on the raid for sure and read 8x32 Bytes with an offset of 64k
> from that file. Than I used bgrep to search for the bytestrings on my
> physical devices. I found five sequent byte strings on one physical
> device, so I think the chunk sice must be bigger than 256k.

Very interesting.  You could go one step further and compare the jpeg
file contents in the first 1M against the locations found to determine
where the chunks actually start and end on each device.  The final
offset will be a chunk multiple before these boundaries.  Or do md5 sums
of 4k blocks to reduce the amount to inspect.

> If I am right, it would mean, that the order of my physical devices is
> sdf1 sdd1 sde1 sdc1 (without knowing which one is the first partition)
> and the offset between sdd1 and the other devices is f0000. Are my
> assumptions correct? How can I go on with this information?

This will help (and looks correct), but I don't remember what we did to
try to find the beginning of your filesystem.  Did we search for a
filesystem signature?  Please re-summarize that.

Phil
