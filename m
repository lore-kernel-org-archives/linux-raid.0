From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 16:01:45 -0500
Message-ID: <CAAMCDeeACZYFtBbMZb2U0jANHLUSvwvhd7i=zb4Bcp1xgnxs+A@mail.gmail.com>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it> <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it> <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

But even if you figured out which it was, you would have no way to
know what writes were still sitting in the cache, it could be pretty
much any writes from the last few seconds (or longer depending on how
exactly the drive firmware works), and it would add additional
complexity to keep a list of recent writes to validate actually
happened in the case of an unexpected drive reset.  This is probably
more of a avoid this failure condition since this failure condition is
not a normal failure mode and more of a very rare failure mode.

On Thu, Aug 17, 2017 at 3:50 PM, Gionatan Danti <g.danti@assyoma.it> wrote:
> Il 17-08-2017 19:33 Wols Lists ha scritto:
>>
>> Which is fine until the drive, bluntly put, lies to you. Cheaper drives
>> are prone to this, in order to look good in benchmarks. Especially as
>> it's hard to detect until you get screwed over by exactly this sort of
>> thing.
>
>
> It's more complex, actually. The hardware did not "lie" to me, as it
> correcly flushes caches when instructed to do.
> The problem is that a micro-powerloss wiped the cache *before* the drive had
> a chance to flush it, and the operating system did not detect this
> condition.
>
> From what I read on the linux-scsi and linux-ide lists, the host OS can not
> tell between a SATA link glitch and a SATA poweroff/poweron. This sound to
> me as a SATA specification problem, rather than a disk/OS one. However, a
> fix should be possible by examining some specific SMART values, which
> identify the powerloss/poweron condition.
>
> Regards.
>
> --
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
