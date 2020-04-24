From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: some questions about uploading a Linux kernel driver FusionRAID
Date: Fri, 24 Apr 2020 10:24:37 +0200
Message-ID: <eb742f1b-fbc2-a47f-dd1b-eec20463fa21@molgen.mpg.de>
References: <6a7c0aba219642de8b3f1cc680d53d85@AM0P193MB0754.EURP193.PROD.OUTLOOK.COM>
 <CAKm37QWKVcPkF0fXKk2499CsYXfU3aMuMWgwa8Nk9HFzVxG7CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKm37QWKVcPkF0fXKk2499CsYXfU3aMuMWgwa8Nk9HFzVxG7CA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Xiaosong Ma <xma@qf.org.qa>, song@kernel.org, linux-raid@vger.kernel.org
Cc: ty-jiang18@mails.tsinghua.edu.cn, Guangyan Zhang <gyzh@tsinghua.edu.cn>, wei-jy19@mails.tsinghua.edu.cn, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Dear Xiaosong, dear Tsinghua,


Am 22.04.20 um 14:26 schrieb Xiaosong Ma:

> This is Xiaosong Ma from Qatar Computing Research Institute. I am
> writing to follow up with the questions posed by a co-author from
> Tsinghua U, regarding upstreaming our alternative md implementation
> that is designed to significantly reduce SSD RAID latency (both median
> and tail) for large SSD pools (such as 20-disk or more).

Sorry for the late reply, and thank you for wanting to upstream the driver.

> We read the Linux kernel upstreaming instructions, and believe that
> our implementation has excellent separability from the current code
> base (as a plug-and-play module with identical interfaces as md).

Is there a chance to integrate it into the current driver, and then 
choose it, when creating the RAID?

> Meanwhile, we wonder whether there are standard test cases or
> preferred applications that we should test our system with, before
> doing code cleaning up. Your guidance is much appreciated.

[…]
> I am Tianyang JIANG, a PhD student from Tsinghua U. We finish a study
> which focuses on achieving consistent low latency for SSD arrays,
> especially timing tail latency in RAID level. We implement a Linux
> kernel driver called FusionRAID and we are interested in uploading
> codes to Linux upstream.
> I notice that I should separate my changes and style-check my codes
> before submitting. Are there any other issues I need to be aware of?
> Thank you for your time.

Is your code in some public git branch to be looked at already?

Otherwise, I believe just posting the patch train with `git send-email` 
and a cover letter, might be the best first step, so the developers can 
comment early before you put too much time into refactoring.

Some easy to reproduce test scripts to verify the performance benefits 
would indeed be nice, but I do not know, if that can be integrated into 
some Linux kernel test infrastructure already.


Kind regards,

Paul
