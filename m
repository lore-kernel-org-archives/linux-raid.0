From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 18 Aug 2017 07:54:34 -0500
Message-ID: <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it> <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it> <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it> <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <784bec391a00b9e074744f31901df636@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have noticed all of the hardware raid controllers explicitly turn
off the disk's write cache so this would eliminate this issue, but the
cost is much slower write times.

It makes the hardware raid controllers (and disk arrays) become
uselessly slow when their battery backup dies and disables the raid
card and/or arrays write cache.

Remember, safe, fast and cheap, you only get to pick 2.   We generally
pick fast and cheap, the disk arrays/raid controllers pick safe and
fast, but not so cheap as a hardware raid controller with write cache
backup of some sort are quite expensive.

On Fri, Aug 18, 2017 at 7:26 AM, Gionatan Danti <g.danti@assyoma.it> wrote:
> Il 18-08-2017 00:51 Wols Lists ha scritto:
>>
>> Except that that is not what should be happening. I don't know my hard
>> drive details, but I believe drives have an instruction "async write
>> this data and let me know when you have done so".
>>
>> This should NOT return "yes I've flushed it TO cache". Which is how you
>> get your problem - the level above thinks it's been safely flushed to
>> disk (because the disk has said "yes I've got it"), but it then gets
>> lost because of your power fluctuation. It should only acknowledge it
>> *after* it's been flushed *from* cache.
>>
>> And this is apparently exactly what cheap drives do ...
>>
>> If the level above says "tell me when it's safely on disk", and the
>> drive truly does as its told, your problem won't happen because the disk
>> block layer will time out waiting for the acknowledgement and retry the
>> write.
>
>
> SATA drives generally guarantee persistent storage on physical medium by
> issuing *two* different FLUSH_CACHE commands, which do *not* form an atomic
> operation. In other words, it's not a problem of "cheap drives" or "lying
> hardware", rather, it seems a specific SATA limitation.
>
> This means the problem can not be solved by simply "buying better disks".
> Traditional flushing/barrier infrastructure simply has *no* method to ensure
> an atomic commit at the hardware level, and if something goes wrong between
> the two flushes, a (small) possibility exists to have corrupted writes
> without I/O errors reported to the upper layer, even in case of sync()
> writes. It's basically as a failing DRAM cache, but with *no* real
> failures...
>
> Newer drivers should implement FUAs, but I don't know if libata alredy uses
> them by default. Anyway, the disk's firmware is free to split a single FUA
> in more internal operations, so I am not sure they solves all problems.
>
> I really found the linux-scsi discussion interesting. Give it a look...
>
>
> Regards.
>
> --
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
