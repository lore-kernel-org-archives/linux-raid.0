Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC15C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 21:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhLOVxn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 16:53:43 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:32692 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230240AbhLOVxm (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 15 Dec 2021 16:53:42 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mxcDV-0002Kv-4C; Wed, 15 Dec 2021 21:53:41 +0000
Message-ID: <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
Date:   Wed, 15 Dec 2021 21:53:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Debugging system hangs
Content-Language: en-GB
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/12/2021 16:45, Roger Heflin wrote:
> If you cannot login to the machine via ssh, also try pinging it.  If
> ping works but ssh does not either ssh died, or the machine is paging
> so heavily that user space cannot respond in a reasonable time.

"Unable to resolve host name 'thewolery'"

Paging is EXTREMELY unlikely with 32GB ram ... :-)
> 
> If the disk were an issue there should be messages about something in
> the disk layer timing out, but it sounds like there aren't any of
> those sorts of messages.  If it was a controller hardware/pci slot/hw
> issue that will in some cases cause an immediate power cycle and boot
> back up.

Where do I look for those after a reboot? The system basically is 
completely unresponsive - so no it's not a reset or anything, the system 
just stops...
> 
> You might also configure kdump, there should be doc's someplace on
> configuring it for your distribution, once configured then test it
> with "echo c > /proc/sysrq-trigger" and that should crash the machine
> and leave you with a kernel core dump + dmesg from the time of the
> crash.   Also if kdump is configured and working it will crash/dump
> memory and typically boot back up automatically.

I'll have to try it, although an autoreboot might not be a particularly 
good idea ...
> 
> On Wed, Dec 15, 2021 at 3:54 AM Wols Lists <antlists@youngman.org.uk> wrote:
>>
>> Don't know if this is off-topic or not, seeing as my system is very much
>> reliant on raid ...
>>
>> But basically I'm seeing the system just stop responding. Typically it's
>> in screensaver mode, I've got a blank screen, and it won't wake up. (I
>> used to think it was something to do with Thunderbird, it mostly
>> happened while TB was hammering the system, but no ...)
>>
>> Today, I had it happen while the system was idle but not in screensaver,
>> I run xosview, and everything was clearly frozen - including xosview.
>>
>> As you might know, my stack is ext4 over lvm (over raid over
>> dm-integrity for /home) over spinning rust.
>>
>> And I run gentoo/systemd - currently on the latest stable kernel afaik,
>> 5.10.76-gentoo-r1 SMP x86_64.
>>
>> Any advice on how to debug a hang - basically I need something that'll
>> just sit there so when it crashes (and I press the reset button to
>> recover) I'll have some sort of trace. It would be nice to prove it's
>> not the disk stack at fault ...
>>
>> Obviously, "set these options in the kernel" won't faze me ...
>>
>> Cheers,
>> Wol
