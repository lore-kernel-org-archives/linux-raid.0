From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Filesystem corruption on RAID1
Date: Mon, 21 Aug 2017 19:52:17 +0200
Message-ID: <64b2a9fb-50fc-8d54-d29e-2e372267df4d@thelounge.net>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
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
 <alpine.DEB.2.20.1708211027370.3655@uplift.swm.pp.se>
 <CAJCQCtRBe2t=qB8nqbtSKO7vGQz_NiyBSon8JAKKNK0V=sba8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRBe2t=qB8nqbtSKO7vGQz_NiyBSon8JAKKNK0V=sba8w@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 21.08.2017 um 19:33 schrieb Chris Murphy:
> On Mon, Aug 21, 2017 at 2:37 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>> On Sun, 20 Aug 2017, Chris Murphy wrote:
>>
>>> Since md doesn't read from both mirrors, it's possible there's a read from
>>> a non-corrupt drive, which presents good information to fsck, which then
>>> sees no reason to fix anything in that block; but the other mirror does have
>>> corruption which thus goes undetected.
>>
>>
>> That was exactly what I wrote.
>>
>>> One way of dealing with it is to scrub (repair) so they both have the same
>>> information to hand over to fsck. Fixups then get replicated to disks by md.
>>
>>
>> Yes, it is, but that would require a full repair before doing fsck. That
>> seems excessive because that will take hours on larger drives.
> 
> Hence we have ZFS and Btrfs and dm-integrity to unambiguously identify
> corruption and prevent it from escaping to higher levels

where do we have ZFS?
where do we have *stable* BTRFS after Redhat gave up recently?
