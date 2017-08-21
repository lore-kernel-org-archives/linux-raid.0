From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 07:57:17 +0200
Message-ID: <04f4fabc549393c4be0d39913821d4bc@assyoma.it>
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
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
 <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
 <CAJCQCtQNx=8-16Xu1ffxqYh04W3mDy_qiPSysBw-g=fwWOtDMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQNx=8-16Xu1ffxqYh04W3mDy_qiPSysBw-g=fwWOtDMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Roger Heflin <rogerheflin@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>, chris@colorremedies.com
List-Id: linux-raid.ids

Il 21-08-2017 01:22 Chris Murphy ha scritto:
> Another way is to split the mirror (make one device faulty), and then
> fix the remaining drive (now degraded). If that goes well, the 2nd
> device can be re-added. Here's a caveat thought: how it resync's will
> depend on the write-intent bitmap being present. I have no idea if
> write-intent bitmaps on two drives can get out of sync and what the
> ensuing behavior is, but I'd like to think md will discover the fixed
> drive event count is higher than the re-added one, and if necessary
> does a full resync, rather than possibly re-introducing any
> corruption.

On the corruption I am replicating (brief SATA power interruptions), the 
event count of both drives where identical, and so was the write bitmap 
(not always, thought).

To be 100% sure to completly copy from the mirror device, you had to 
re-add the corrupted driver as a spare, by using "--add-spare". From the 
man page:

"--add-spare
Add a device as a spare. This is similar to --add except that it does 
not attempt --re-add first. The device will be added as a spare even if 
it looks like it could be an recent member of the array."

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
