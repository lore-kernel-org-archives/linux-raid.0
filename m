From: Oguz Yilmaz <oguzyilmazlist@gmail.com>
Subject: Re: Raid 0+1
Date: Sat, 1 Dec 2012 15:11:55 +0200
Message-ID: <CAAo+KFn82hYUak4mvqMfix8UEPC7uwdvmbmRFLikQFqYDjNrHg@mail.gmail.com>
References: <CAAo+KF=-XStwczZvxPh7jgLZzwEAD71XWWg0h5HBXekBO8-5vQ@mail.gmail.com>
 <50B8C26C.7000807@profitbricks.com> <50B8C55E.1050902@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B8C55E.1050902@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 30, 2012 at 4:40 PM, Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:
> On 30.11.2012 15:27, Sebastian Riemer wrote:
>> On 30.11.2012 14:25, Oguz Yilmaz wrote:
>>> What is the suggested way for making Raid 0+1 (not 1+0)?
>>> Is it possible to make it without LVM?
>>
>> Yes, it is possible but it only makes sense if you want to mirror to
>> another server as most people know that the alternative DRBD is too slow
>> for serious storage requirements.
>>
>> Create the RAID-0 first, then take your RAID-0 device and e.g. an iSCSI
>> device from another storage server with the same setup and create a
>> RAID-1 over them. Then, you've got your stacked MD layers.
>>


Why do we need another storage server.
IF I create
md0 Raid0 (sda1 + sda2)
md1 Raid0 (sdc1 + sdc2)

then is it possible to create
md2 Raid1 (md0 + md1)

like md?

Regards,

>> With the flag write-mostly you can even tell the read balancing that the
>> remote device is slower than the local one.
>>
>
> I've forgotten to mention: You need a kernel >= 3.4.2 for this.
>
> Earlier kernels don't support bvec merging and therefore every IO is a
> slow 4 KiB IO in that RAID 0+1 setup.
>
> Btw.: LVM also supports striping but letting LVM do striping is only
> useful if you want to build RAID 1+0. The speed is the same as "RAID 1+0
> + LVM". Only that raid10 driver doesn't scale good for >= 24 HDDs.
