From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 23:21:38 +0200
Message-ID: <0d30990378519fa07e13da11058aa4c3@assyoma.it>
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
 <CAAMCDeeACZYFtBbMZb2U0jANHLUSvwvhd7i=zb4Bcp1xgnxs+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeeACZYFtBbMZb2U0jANHLUSvwvhd7i=zb4Bcp1xgnxs+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il 17-08-2017 23:01 Roger Heflin ha scritto:
> But even if you figured out which it was, you would have no way to
> know what writes were still sitting in the cache, it could be pretty
> much any writes from the last few seconds (or longer depending on how
> exactly the drive firmware works), and it would add additional
> complexity to keep a list of recent writes to validate actually
> happened in the case of an unexpected drive reset.  This is probably
> more of a avoid this failure condition since this failure condition is
> not a normal failure mode and more of a very rare failure mode.

Yes, but having identified the power-cycled disk, the system can not 
take the most sensible action.
For example, it can re-sync it with its mirror disk, basically treating 
it as a --add-spare action.
Or it can simply considering the disk as failing, kicking off it from 
the array and sending an alert email.

What the system should not do is doing nothing: as differences 
accumulates, reading from the array become non-deterministic. In other 
words, two reads can produce two different results, based on what disk 
was queried. This *will* cause all sort of problems.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
