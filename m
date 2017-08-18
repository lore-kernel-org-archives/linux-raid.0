From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 18 Aug 2017 21:42:25 +0200
Message-ID: <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
 <59961DD7.3060208@youngman.org.uk>
 <784bec391a00b9e074744f31901df636@assyoma.it>
 <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il 18-08-2017 14:54 Roger Heflin ha scritto:
> I have noticed all of the hardware raid controllers explicitly turn
> off the disk's write cache so this would eliminate this issue, but the
> cost is much slower write times.

True...

> It makes the hardware raid controllers (and disk arrays) become
> uselessly slow when their battery backup dies and disables the raid
> card and/or arrays write cache.

...true...

> Remember, safe, fast and cheap, you only get to pick 2.   We generally
> pick fast and cheap, the disk arrays/raid controllers pick safe and
> fast, but not so cheap as a hardware raid controller with write cache
> backup of some sort are quite expensive.

...and true. I am not arguing any of these points.

What really surprised me was to realize that, facing micro-powerlosses, 
*even sync() writes* can be vulnerable to undetected data loss, at least 
when not using FUAs (using instead the common barrier infrastructure).

So while many (old) mismatch_cnt reports on RAID1/10 arrays where 
dismissed as "don't bother, it's a harmless RAID1 thing", I really think 
than some were genuine corruptions due to micro powerlosses and similar 
causes.

If nothing more, such reports really emphasize the need to have a 
"trusted" mismatch_cnt for mirrored arrays, even in the face of some 
performance losses (due to no using zero copy anymore).

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
