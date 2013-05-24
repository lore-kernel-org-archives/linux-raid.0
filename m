From: Jim Santos <iluvgadgets@gmail.com>
Subject: Re: Moving RAID1 disks between systems
Date: Fri, 24 May 2013 17:58:21 -0400
Message-ID: <CAGPLN=ut9sacwkYuaVbDP3u3dhm-WTZQw2gnAoVjMWFBEbqTCg@mail.gmail.com>
References: <CAGPLN=s0nBeuHk75KSaKV2LS1MxYrdVmXjG7eM+dP36bOSbA-A@mail.gmail.com>
	<CACJz6Qt-zULSobEDqo306gow4wAvx1LQdXBf3K5XHm36rDKE4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qt-zULSobEDqo306gow4wAvx1LQdXBf3K5XHm36rDKE4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 24, 2013 at 2:30 PM, Drew <drew.kay@gmail.com> wrote:
>
> Hi Jim,
>
> You should have no troubles reassembling the array on a new machine.
> From what I understand, md raid doesn't depend on device names for
> assembling arrays, it has some internal UUID's to distinguish which
> array a member disk belongs to.
>
> mdadm --assemble --scan is pretty much all you need (and won't break
> anything in the process)
>
>
Is there a way to rename md devices?  It would be useful in general and
maybe necessary if assembling the arrays from the other system causes
md device name collisions
