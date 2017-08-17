From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 18:33:43 +0100
Message-ID: <5995D377.9080100@youngman.org.uk>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7ca98351facca6e3668d3271422e1376@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>, Roger Heflin <rogerheflin@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/08/17 15:31, Gionatan Danti wrote:
> However, the entire idea of barriers/cache flushes/FUAs was to *safely
> enable* unprotected write caches, even in the face of powerloss. Indeed,
> for full-system powerloss their are adequate. However, device-level
> micro-powerlosses seem to pose an bigger threat to data reliability.

Which is fine until the drive, bluntly put, lies to you. Cheaper drives
are prone to this, in order to look good in benchmarks. Especially as
it's hard to detect until you get screwed over by exactly this sort of
thing.

Cheers,
Wol
