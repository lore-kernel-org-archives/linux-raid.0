From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 13 Jul 2017 19:48:29 -0600
Message-ID: <CAJCQCtS=o27zF_sUEv0rTos_0x_7tNMdudBaDDOwxSvTz3zE5w@mail.gmail.com>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 13, 2017 at 4:34 PM, Gionatan Danti <g.danti@assyoma.it> wrote:
> Il 13-07-2017 23:34 Reindl Harald ha scritto:
>>
>> maybe because the disk is, well, not in a good shape and don't know
>> that by itself
>>
>
> But the kernel *does* know that, as the dmesg entries clearly show.
> Basically, some SATA commands timed-out and/or were aborted. As the kernel
> reported these erros in dmesg, why do not use these information to stop a
> failing disk?
>
>>
>> (and no filesystems with checksums won't magically recover
>> your data, they just tell you realier they are gone)
>>
>
> Checksummed filesystem that integrates their block-level management (read:
> ZFS or BTRFS) can recover the missing/corrupted data by the healthy disks,
> discarging corrupted data based on the checksum mismatch.
>
> Anyway, this has nothing to do with linux software RAID. I was only
> "thinking loud" :)
> Thanks.
>
>


Dealing with device betrayal at a hardware level is a difficult
problem. I'm under the impression the md driver is very intolerant of
write failure and would eject a drive even with a single failed write?
It would seem to be disqualifying for RAID.

Btrfs still tolerates many errors, read and write, so it can still be
a problem there too. But yes it does have an independent way to
unambiguously determine whether file system metadata, or extent data,
is corrupt. It also often keeps two copies of metadata (the file
system itself). Another option (read-only) is dm-verity, but that is
not RAID, it uses forward error correction and cryptographic hash
verification.



-- 
Chris Murphy
