From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 00:34:59 +0200
Message-ID: <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Il 13-07-2017 23:34 Reindl Harald ha scritto:
> maybe because the disk is, well, not in a good shape and don't know
> that by itself
> 

But the kernel *does* know that, as the dmesg entries clearly show. 
Basically, some SATA commands timed-out and/or were aborted. As the 
kernel reported these erros in dmesg, why do not use these information 
to stop a failing disk?

> 
> (and no filesystems with checksums won't magically recover
> your data, they just tell you realier they are gone)
> 

Checksummed filesystem that integrates their block-level management 
(read: ZFS or BTRFS) can recover the missing/corrupted data by the 
healthy disks, discarging corrupted data based on the checksum mismatch.

Anyway, this has nothing to do with linux software RAID. I was only 
"thinking loud" :)
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
