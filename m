From: Mike Hartman <mike@hartmanipulation.com>
Subject: RE: RAID showing all devices as spares after partial unplug
Date: Sat, 17 Sep 2011 23:59:16 -0400
Message-ID: <CAB=7dh=xshrAfZzSaekPL0kJe0M2mKbOaupaFyeWVC6SnkT6=g@mail.gmail.com>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com>
	<CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com>
	<CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com>
	<20110918011749.98312581F7A@mail.futurelabusa.com>
	<CAB=7dh=PymkpqRLTWiNzD-+n=XwEWnPN8nQwXg1=UmiJmZ1b1w@mail.gmail.com>
	<20110918025839.85C86581F7C@mail.futurelabusa.com>
	<CAB=7dhmBDRFYnmoUJjEB2SfyQe8sB+WjC7AkK080iSRwA4RTzg@mail.gmail.com>
	<CAB=7dh=9UcEWJjLbOvPLu1Ubij0X4i6+SQ-6L9VE5gHLvcJVcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB=7dh=9UcEWJjLbOvPLu1Ubij0X4i6+SQ-6L9VE5gHLvcJVcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 17, 2011 at 11:07 PM, Mike Hartman
<mike@hartmanipulation.com> wrote:
> Yikes. That's a pretty terrifying prospect.
>
> On Sat, Sep 17, 2011 at 10:57 PM, Jim Schatzman
> <james.schatzman@futurelabusa.com> wrote:
>> Mike-
>>
>> See my response below.
>>
>> Good luck!
>>
>> Jim
>>
>>
>> At 07:34 PM 9/17/2011, Mike Hartman wrote:
>>>On Sat, Sep 17, 2011 at 9:16 PM, Jim Schatzman
>>><james.schatzman@futurelabusa.com> wrote:
>>>> Mike-
>>>>
>>>> I have seen very similar problems. I regret that electronics engin=
eers cannot design more secure connectors. eSata connector are terrible=
 - they come loose at the slightest tug. For this reason, I am graduall=
y abandoning eSata enclosures and going to internal drives only. Fortun=
ately, there are some inexpensive RAID chassis available now.
>>>>
>>>> I tried the same thing as you. I removed the array(s) from mdadm.c=
onf and I wrote a script for "/etc/cron.reboot" which assembles the arr=
ay, "no-degraded". Doing this seems to minimize the damage caused by dr=
ives prior to a reboot. However, if the drives are disconnected while L=
inux is up, then either the array will stay up but some drives will bec=
ome stale or the array will be stopped. The behavior I usually see is t=
hat all the drives that went offline now become "spare".
>>>>
>>>
>>>That sounds similar, although I only had 4/11 go offline and now
>>>they're ALL spare.
>>>
>>>> It would be nice if md would just reassemble the array once all th=
e drives come back online. Unfortunately, it doesn't. I would run mdadm=
 -E against all the drives/partitions, verifying that the metadata all =
indicates that they are/were part of the expected array.
>>>
>>>I ran mdadm -E and they all correctly appear as part of the array:
>>>
>>>for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdad=
m
>>>-E $d | grep Role; done
>>>
>>>/dev/sdc1
>>> =A0 Device Role : Active device 5
>>>/dev/sdd1
>>> =A0 Device Role : Active device 4
>>>/dev/sdf1
>>> =A0 Device Role : Active device 2
>>>/dev/sdh1
>>> =A0 Device Role : Active device 0
>>>/dev/sdj1
>>> =A0 Device Role : Active device 10
>>>/dev/sdk1
>>> =A0 Device Role : Active device 7
>>>/dev/sdl1
>>> =A0 Device Role : Active device 8
>>>/dev/sdm1
>>> =A0 Device Role : Active device 9
>>>/dev/sdn1
>>> =A0 Device Role : Active device 1
>>>/dev/md1p1
>>> =A0 Device Role : Active device 3
>>>/dev/md3p1
>>> =A0 Device Role : Active device 6
>>>
>>>But they have varying event counts (although all pretty close togeth=
er):
>>>
>>>for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdad=
m
>>>-E $d | grep Event; done
>>>
>>>/dev/sdc1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/sdd1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/sdf1
>>> =A0 =A0 =A0 =A0 Events : 1756737
>>>/dev/sdh1
>>> =A0 =A0 =A0 =A0 Events : 1756737
>>>/dev/sdj1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/sdk1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/sdl1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/sdm1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/sdn1
>>> =A0 =A0 =A0 =A0 Events : 1756743
>>>/dev/md1p1
>>> =A0 =A0 =A0 =A0 Events : 1756737
>>>/dev/md3p1
>>> =A0 =A0 =A0 =A0 Events : 1756740
>>>
>>>And they don't seem to agree on the overall status of the array. The
>>>ones that never went down seem to think the array is missing 4 nodes=
,
>>>while the ones that went down seem to think all the nodes are good:
>>>
>>>for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdad=
m
>>>-E $d | grep State; done
>>>
>>>/dev/sdc1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdd1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdf1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdh1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdj1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdk1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdl1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdm1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/sdn1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/md1p1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>/dev/md3p1
>>> =A0 =A0 =A0 =A0 =A0State : clean
>>> =A0 Array State : .A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missin=
g)
>>>
>>>So it seems like overall the array is intact, I just need to convinc=
e
>>>it of that fact.
>>>
>>>> At that point, you should be able ro re-create the RAID. Be sure y=
ou list the drives in the correct order. Once the array is going again,=
 mount the resulting partitions RO and verify that the data is o.k. bef=
ore going RW.
>>>
>>>Could you be more specific about how exactly I should re-create the
>>>RAID? Should I just do --assemble --force?
>>
>>
>>
>> =A0--> =A0No. As far as I know, you have to use "-C"/"--create". =A0=
You need to use exactly the same array parameters that were used to cre=
ate the array the first time. Same metadata version. Same stripe size. =
Raid mode the same. Physical devices in the same order.
>>
>> Why do you have to use "--create", and thus open the door for catast=
ropic error?? I have asked the same question myself. Maybe, if more peo=
ple ping Neil Brown on this, he may be willing to find another way.
>>
>>
>>


Is there any way to construct the exact create command using the info
given by mdadm -E? This array started as a RAID 5 that was reshaped
into a 6 and then grown many times, so I don't have a single original
create command lying around to reference.

I know the devices and their order (as previously listed) - are all
the other options I need to specify part of the -E output? If so, can
someone clarify how that maps into the command?

Here's an example output:

mdadm -E /dev/sdh1

/dev/sdh1:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 1.2
=A0 =A0Feature Map : 0x1
=A0 =A0 Array UUID : 714c307e:71626854:2c2cc6c8:c67339a0
=A0 =A0 =A0 =A0 =A0 Name : odin:0 =A0(local to host odin)
=A0Creation Time : Sat Sep =A04 12:52:59 2010
=A0 =A0 Raid Level : raid6
=A0 Raid Devices : 11

=A0Avail Dev Size : 2929691614 (1396.99 GiB 1500.00 GB)
=A0 =A0 Array Size : 26367220224 (12572.87 GiB 13500.02 GB)
=A0Used Dev Size : 2929691136 (1396.99 GiB 1500.00 GB)
=A0 =A0Data Offset : 2048 sectors
=A0 Super Offset : 8 sectors
=A0 =A0 =A0 =A0 =A0State : clean
=A0 =A0Device UUID : 384875df:23db9d35:f63202d0:01c03ba2

Internal Bitmap : 2 sectors from superblock
=A0 =A0Update Time : Thu Sep 15 05:10:57 2011
=A0 =A0 =A0 Checksum : f679cecb - correct
=A0 =A0 =A0 =A0 Events : 1756737

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 256K

=A0 Device Role : Active device 0
=A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

Mike


>>>>
>>>> Jim
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> At 04:16 PM 9/17/2011, Mike Hartman wrote:
>>>>>I should add that the mdadm command in question actually ends in
>>>>>/dev/md0, not /dev/md3 (that's for another array). So the device n=
ame
>>>>>for the array I'm seeing in mdstat DOES match the one in the assem=
ble
>>>>>command.
>>>>>
>>>>>On Sat, Sep 17, 2011 at 4:39 PM, Mike Hartman <mike@hartmanipulati=
on.com> wrote:
>>>>>> I have 11 drives in a RAID 6 array. 6 are plugged into one esata
>>>>>> enclosure, the other 4 are in another. These esata cables are pr=
one to
>>>>>> loosening when I'm working on nearby hardware.
>>>>>>
>>>>>> If that happens and I start the host up, big chunks of the array=
 are
>>>>>> missing and things could get ugly. Thus I cooked up a custom sta=
rtup
>>>>>> script that verifies each device is present before starting the =
array
>>>>>> with
>>>>>>
>>>>>> mdadm --assemble --no-degraded -u 4fd7659f:12044eff:ba25240d:
>>>>>> de22249d /dev/md3
>>>>>>
>>>>>> So I thought I was covered. In case something got unplugged I wo=
uld
>>>>>> see the array failing to start at boot and I could shut down, fi=
x the
>>>>>> cables and try again. However, I hit a new scenario today where =
one of
>>>>>> the plugs was loosened while everything was turned on.
>>>>>>
>>>>>> The good news is that there should have been no activity on the =
array
>>>>>> when this happened, particularly write activity. It's a big medi=
a
>>>>>> partition and sees much less writing then reading. I'm also the =
only
>>>>>> one that uses it and I know I wasn't transferring anything. The =
system
>>>>>> also seems to have immediately marked the filesystem read-only,
>>>>>> because I discovered the issue when I went to write to it later =
and
>>>>>> got a "read-only filesystem" error. So I believe the state of th=
e
>>>>>> drives should be the same - nothing should be out of sync.
>>>>>>
>>>>>> However, I shut the system down, fixed the cables and brought it=
 back
>>>>>> up. All the devices are detected by my script and it tries to st=
art
>>>>>> the array with the command I posted above, but I've ended up wit=
h
>>>>>> this:
>>>>>>
>>>>>> md0 : inactive sdn1[1](S) sdj1[9](S) sdm1[10](S) sdl1[11](S)
>>>>>> sdk1[12](S) md3p1[8](S) sdc1[6](S) sdd1[5](S) md1p1[4](S) sdf1[3=
](S)
>>>>>> sdh1[0](S)
>>>>>> =A0 =A0 =A0 16113893731 blocks super 1.2
>>>>>>
>>>>>> Instead of all coming back up, or still showing the unplugged dr=
ives
>>>>>> missing, everything is a spare? I'm suitably disturbed.
>>>>>>
>>>>>> It seems to me that if the data on the drives still reflects the
>>>>>> last-good data from the array (and since no writing was going on=
 it
>>>>>> should) then this is just a matter of some metadata getting mess=
ed up
>>>>>> and it should be fixable. Can someone please walk me through the
>>>>>> commands to do that?
>>>>>>
>>>>>> Mike
>>>>>>
>>>>>--
>>>>>To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>>>the body of a message to majordomo@vger.kernel.org
>>>>>More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>>
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
