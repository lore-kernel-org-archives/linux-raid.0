From: "Majed B." <majedb@gmail.com>
Subject: Re: Why do arrays start without some components?
Date: Tue, 16 Mar 2010 11:08:51 +0300
Message-ID: <70ed7c3e1003160108x4407b129r95102d3930c49c92@mail.gmail.com>
References: <40b437201003151326t39be3b2hc3df6f79802b9b7e@mail.gmail.com>
	<4B9EA0E8.3020301@shiftmail.org> <40b437201003151426h7bc721e2m69242c044a074e24@mail.gmail.com>
	<40b437201003152234g7db90026k92d663bb3f10aaaf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40b437201003152234g7db90026k92d663bb3f10aaaf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you are unable to access a certain disk, that disk has most likely f=
ailed.

Also, did you change the partition types to "FD" (RAID Autodetect)?
I once forgot to do that and that affected partition kept jumping out
of the array.

On Tue, Mar 16, 2010 at 8:34 AM, Simon Matthews
<simon.d.matthews@gmail.com> wrote:
> On Mon, Mar 15, 2010 at 1:26 PM, Simon Matthews
> <simon.d.matthews@gmail.com> wrote:
>> On Mon, Mar 15, 2010 at 2:04 PM, Asdo <asdo@shiftmail.org> wrote:
>>> Simon Matthews wrote:
>>>>
>>>> I have a couple of machines on which this is happening now --
>>>>
>>>> When the machine boots, the RAID arrays (RAID 1) start, but each a=
rray
>>>> only has one component device. I can add the other component again
>>>> (using mdadm --add ... ) and the array will sync up, but next time=
 it
>>>> boots, I have to do the same once more.
>>>>
>>>> Why is this and how do I fix it?
>>>>
>>>
>>> Might that be a /etc/mdadm/mdadm.conf in the initramfs listing fewe=
r devices
>>> than it should?
>>> I am not sure (because in this case maybe it shouldn't autoassemble=
 the
>>> array at all), but have a look by unpacking your initramfs. If yes,=
 update
>>> it.
>>
>> I don't have an initramfs. This is a Gentoo system and I built the
>> kernel with all the drivers required to boot built in. This includes
>> RAID support.
>>
>>> Or could that be a controller that shows the disks to the kernel to=
o late...
>>> do you have multiple controllers?
>>
>> I don't think so, on one machine they are SATA drives, but only one =
controller.
>>
>> But, perhaps on the other machine, this may be happening, since the
>> drive that includes the component that is left out of the array is o=
n
>> an add-in controller. On this machine, the problematic array uses ID=
E
>> drives for its components.
>
> Replying to my own email -- bad form, I know. However, some additiona=
l
> information. The components that do form the degraded array on boot u=
p
> on the all-SATA machine are all /dev/sdbX and the missing components
> are all /dev/sdaX. I think this makes it unlikely that the controller
> is showing the disks to the kernel too late, since I think it is
> likely that the /dev/sdaX disks are shown first.
>
> Simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
