From: David Brown <david@westcontrol.com>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 11:08:11 +0200
Message-ID: <ipls7b$u97$2@dough.gmane.org>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>	<1304051980.3105.46.camel@localhost>	<8739kyf53e.fsf@servo.factory.finestructure.net>	<1304294457.2833.111.camel@localhost> <20110502102224.7787d6bd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110502102224.7787d6bd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/2011 02:22, NeilBrown wrote:
> On Mon, 02 May 2011 01:00:57 +0100 Ben Hutchings<ben@decadent.org.uk>  wrote:
>
>> On Sun, 2011-05-01 at 15:06 -0700, Jameson Graef Rollins wrote:
>>> On Fri, 29 Apr 2011 05:39:40 +0100, Ben Hutchings<ben@decadent.org.uk>  wrote:
>>>> On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
>>>>> I run what I imagine is a fairly unusual disk setup on my laptop,
>>>>> consisting of:
>>>>>
>>>>>    ssd ->  raid1 ->  dm-crypt ->  lvm ->  ext4
>>>>>
>>>>> I use the raid1 as a backup.  The raid1 operates normally in degraded
>>>>> mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
>>>>> then fail/remove the external hdd.
>>>>
>>>> Well, this is not expected to work.  Possibly the hot-addition of a disk
>>>> with different bio restrictions should be rejected.  But I'm not sure,
>>>> because it is safe to do that if there is no mounted filesystem or
>>>> stacking device on top of the RAID.
>>>
>>> Hi, Ben.  Can you explain why this is not expected to work?  Which part
>>> exactly is not expected to work and why?
>>
>> Adding another type of disk controller (USB storage versus whatever the
>> SSD interface is) to a RAID that is already in use.
>
> Normally this practice is perfectly OK.
> If a filesysytem is mounted directly from an md array, then adding devices
> to the array at any time is fine, even if the new devices have quite
> different characteristics than the old.
>
> However if there is another layer in between md and the filesystem - such as
> dm - then there can be problem.
> There is no mechanism in the kernl for md to tell dm that things have
> changed, so dm never changes its configuration to match any change in the
> config of the md device.
>

While I can see that there might be limitations in informing the dm 
layer about changes to the md layer, I fail to see what changes we are 
talking about.  If the OP were changing the size of the raid1, for 
example, then that would be a metadata change that needed to propagate 
up so that lvm could grow its physical volume.  But the dm layer should 
not care if a disk is added or removed from the md raid1 set - as long 
as the /dev/mdX device stays online and valid, it should work correctly.


