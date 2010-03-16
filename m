From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Why do arrays start without some components?
Date: Mon, 15 Mar 2010 22:34:19 -0700
Message-ID: <40b437201003152234g7db90026k92d663bb3f10aaaf@mail.gmail.com>
References: <40b437201003151326t39be3b2hc3df6f79802b9b7e@mail.gmail.com>
	 <4B9EA0E8.3020301@shiftmail.org>
	 <40b437201003151426h7bc721e2m69242c044a074e24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40b437201003151426h7bc721e2m69242c044a074e24@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 1:26 PM, Simon Matthews
<simon.d.matthews@gmail.com> wrote:
> On Mon, Mar 15, 2010 at 2:04 PM, Asdo <asdo@shiftmail.org> wrote:
>> Simon Matthews wrote:
>>>
>>> I have a couple of machines on which this is happening now --
>>>
>>> When the machine boots, the RAID arrays (RAID 1) start, but each array
>>> only has one component device. I can add the other component again
>>> (using mdadm --add ... ) and the array will sync up, but next time it
>>> boots, I have to do the same once more.
>>>
>>> Why is this and how do I fix it?
>>>
>>
>> Might that be a /etc/mdadm/mdadm.conf in the initramfs listing fewer devices
>> than it should?
>> I am not sure (because in this case maybe it shouldn't autoassemble the
>> array at all), but have a look by unpacking your initramfs. If yes, update
>> it.
>
> I don't have an initramfs. This is a Gentoo system and I built the
> kernel with all the drivers required to boot built in. This includes
> RAID support.
>
>> Or could that be a controller that shows the disks to the kernel too late...
>> do you have multiple controllers?
>
> I don't think so, on one machine they are SATA drives, but only one controller.
>
> But, perhaps on the other machine, this may be happening, since the
> drive that includes the component that is left out of the array is on
> an add-in controller. On this machine, the problematic array uses IDE
> drives for its components.

Replying to my own email -- bad form, I know. However, some additional
information. The components that do form the degraded array on boot up
on the all-SATA machine are all /dev/sdbX and the missing components
are all /dev/sdaX. I think this makes it unlikely that the controller
is showing the disks to the kernel too late, since I think it is
likely that the /dev/sdaX disks are shown first.

Simon
