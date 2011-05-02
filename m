From: David Brown <david@westcontrol.com>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 12:32:34 +0200
Message-ID: <ipm15i$puk$1@dough.gmane.org>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>	<1304051980.3105.46.camel@localhost>	<8739kyf53e.fsf@servo.factory.finestructure.net>	<1304294457.2833.111.camel@localhost>	<20110502102224.7787d6bd@notabene.brown>	<ipls7b$u97$2@dough.gmane.org> <20110502200057.34806257@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110502200057.34806257@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/2011 12:00, NeilBrown wrote:
> On Mon, 02 May 2011 11:08:11 +0200 David Brown<david@westcontrol.com>  wrote:
>
>> On 02/05/2011 02:22, NeilBrown wrote:
>>> On Mon, 02 May 2011 01:00:57 +0100 Ben Hutchings<ben@decadent.org.uk>   wrote:
>>>
>>>> On Sun, 2011-05-01 at 15:06 -0700, Jameson Graef Rollins wrote:
>>>>> On Fri, 29 Apr 2011 05:39:40 +0100, Ben Hutchings<ben@decadent.org.uk>   wrote:
>>>>>> On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
>>>>>>> I run what I imagine is a fairly unusual disk setup on my laptop,
>>>>>>> consisting of:
>>>>>>>
>>>>>>>     ssd ->   raid1 ->   dm-crypt ->   lvm ->   ext4
>>>>>>>
>>>>>>> I use the raid1 as a backup.  The raid1 operates normally in degraded
>>>>>>> mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
>>>>>>> then fail/remove the external hdd.
>>>>>>
>>>>>> Well, this is not expected to work.  Possibly the hot-addition of a disk
>>>>>> with different bio restrictions should be rejected.  But I'm not sure,
>>>>>> because it is safe to do that if there is no mounted filesystem or
>>>>>> stacking device on top of the RAID.
>>>>>
>>>>> Hi, Ben.  Can you explain why this is not expected to work?  Which part
>>>>> exactly is not expected to work and why?
>>>>
>>>> Adding another type of disk controller (USB storage versus whatever the
>>>> SSD interface is) to a RAID that is already in use.
>>>
>>> Normally this practice is perfectly OK.
>>> If a filesysytem is mounted directly from an md array, then adding devices
>>> to the array at any time is fine, even if the new devices have quite
>>> different characteristics than the old.
>>>
>>> However if there is another layer in between md and the filesystem - such as
>>> dm - then there can be problem.
>>> There is no mechanism in the kernl for md to tell dm that things have
>>> changed, so dm never changes its configuration to match any change in the
>>> config of the md device.
>>>
>>
>> While I can see that there might be limitations in informing the dm
>> layer about changes to the md layer, I fail to see what changes we are
>> talking about.  If the OP were changing the size of the raid1, for
>> example, then that would be a metadata change that needed to propagate
>> up so that lvm could grow its physical volume.  But the dm layer should
>> not care if a disk is added or removed from the md raid1 set - as long
>> as the /dev/mdX device stays online and valid, it should work correctly.
>>
>
> The changes we are talking about are "maximum supported request size" aka
> max_sectors.
>
> md sets max_sectors from the minimum of the max_sectors values of all
> component devices.  Of course if a device changes its max_sectors value, md
> won't notice.
>
> dm sets max_sectors from the minimum of the max_sectors values of all
> component devices.  Of course if a device changes its max_sectors value
> after it has been included in the map, dm doesn't notice.
>
> Every time a filesystem creates a request, it check the max_sectors of
> the device and limits the request size accordingly.
>
> So if I add a device to an md/raid array which has a smaller max_sectors
> value, then the max_sectors of the md array will change, but no-one will
> notice.
>
> There might be a way to tell dm to re-evaluate max_sectors etc, I don't
> know.  But even if there was having to do that would be a clumsy solution.
>

I would think the one possible solution would be that if one layer (or 
the filesystem) requested too large a block from the next layer, there 
would be an error code returned.  This would avoid the need to do any 
re-evaluation under normal circumstances - there would only be extra 
effort if the devices changed and caused a problem.

Another idea would be for a block layer to transparently split the 
request into multiple smaller requests if needed - but that may cause 
other complications such as when the order and atomicity of requests is 
important.

Is there such a big variation of the maximum supported request size?  Or 
could it simply be fixed at some value - and any devices that can't 
support that directly would emulate it with multiple requests?

I know next to nothing about the internals of the block layers (in case 
that's not obvious from my posts...).  But this strikes me as a strange 
limitation to have on the flexibility of block layers.

I can see that in the great majority of cases, the maximum request size 
would be static - as the layers of raid, dm, etc., are built up, with 
the filesystem mounted on top, then the request size limitations are 
passed on.  What is unusual about the circumstances we are discussing is 
that the maximum request size may change dynamically.



