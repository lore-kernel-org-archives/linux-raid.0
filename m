From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: help requested for mdadm grow error
Date: Mon, 25 May 2020 19:55:04 +0100
Message-ID: <5ECC1488.3010804@youngman.org.uk>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Grawert <thomasgrawert0282@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/05/20 19:18, Thomas Grawert wrote:
> 
>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>
>> Especially
>>
>> https://raid.wiki.kernel.org/index.php/Asking_for_help
>>
>> More will follow but we need this info.
> 
> You´re totally right. Sorry for not quoting.
> 
> All drives are new.
> 
> root@nas:~# smartctl --xall /dev/sda
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-12-amd64] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
> 
> === START OF INFORMATION SECTION ===
> Device Model:     WDC WD120EFAX-68UNTN0

The EFAX had me worried a moment, but these are 12TB Reds? That's fine.
A lot of the smaller drives are now shingled, ie not fit for purpose!

Debian 10 - I don't know my Debians - how up to date is that? Is it a
new kernel with not much backports, or an old kernel full of backports?

What version of mdadm?


That said, everything looks good. There are known problems - WITH FIXES
- growing a raid 5 so I suspect you've fallen foul of one. I'd sort out
a rescue disk that you can boot off as you might need it. Once we know a
bit more the fix is almost certainly a rescue disk and resume the
reshape, or a revert-reshape and then reshaping from a rescue disk. At
which point, you'll get your array back with everything intact.

Cheers,
Wol
