From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Sat, 17 Sep 2011 23:07:17 -0400
Message-ID: <CAB=7dhmBDRFYnmoUJjEB2SfyQe8sB+WjC7AkK080iSRwA4RTzg@mail.gmail.com>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com>
	<CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com>
	<CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com>
	<20110918011749.98312581F7A@mail.futurelabusa.com>
	<CAB=7dh=PymkpqRLTWiNzD-+n=XwEWnPN8nQwXg1=UmiJmZ1b1w@mail.gmail.com>
	<20110918025839.85C86581F7C@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110918025839.85C86581F7C@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yikes. That's a pretty terrifying prospect.

On Sat, Sep 17, 2011 at 10:57 PM, Jim Schatzman
<james.schatzman@futurelabusa.com> wrote:
> Mike-
>
> See my response below.
>
> Good luck!
>
> Jim
>
>
> At 07:34 PM 9/17/2011, Mike Hartman wrote:
>>On Sat, Sep 17, 2011 at 9:16 PM, Jim Schatzman
>><james.schatzman@futurelabusa.com> wrote:
>>> Mike-
>>>
>>> I have seen very similar problems. I regret that electronics engine=
ers cannot design more secure connectors. eSata connector are terrible =
- they come loose at the slightest tug. For this reason, I am gradually=
 abandoning eSata enclosures and going to internal drives only. Fortuna=
tely, there are some inexpensive RAID chassis available now.
>>>
>>> I tried the same thing as you. I removed the array(s) from mdadm.co=
nf and I wrote a script for "/etc/cron.reboot" which assembles the arra=
y, "no-degraded". Doing this seems to minimize the damage caused by dri=
ves prior to a reboot. However, if the drives are disconnected while Li=
nux is up, then either the array will stay up but some drives will beco=
me stale or the array will be stopped. The behavior I usually see is th=
at all the drives that went offline now become "spare".
>>>
>>
>>That sounds similar, although I only had 4/11 go offline and now
>>they're ALL spare.
>>
>>> It would be nice if md would just reassemble the array once all the=
 drives come back online. Unfortunately, it doesn't. I would run mdadm =
-E against all the drives/partitions, verifying that the metadata all i=
ndicates that they are/were part of the expected array.
>>
>>I ran mdadm -E and they all correctly appear as part of the array:
>>
>>for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdadm
>>-E $d | grep Role; done
>>
>>/dev/sdc1
>> =A0 Device Role : Active device 5
>>/dev/sdd1
>> =A0 Device Role : Active device 4
>>/dev/sdf1
>> =A0 Device Role : Active device 2
>>/dev/sdh1
>> =A0 Device Role : Active device 0
>>/dev/sdj1
>> =A0 Device Role : Active device 10
>>/dev/sdk1
>> =A0 Device Role : Active device 7
>>/dev/sdl1
>> =A0 Device Role : Active device 8
>>/dev/sdm1
>> =A0 Device Role : Active device 9
>>/dev/sdn1
>> =A0 Device Role : Active device 1
>>/dev/md1p1
>> =A0 Device Role : Active device 3
>>/dev/md3p1
>> =A0 Device Role : Active device 6
>>
>>But they have varying event counts (although all pretty close togethe=
r):
>>
>>for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdadm
>>-E $d | grep Event; done
>>
>>/dev/sdc1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/sdd1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/sdf1
>> =A0 =A0 =A0 =A0 Events : 1756737
>>/dev/sdh1
>> =A0 =A0 =A0 =A0 Events : 1756737
>>/dev/sdj1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/sdk1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/sdl1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/sdm1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/sdn1
>> =A0 =A0 =A0 =A0 Events : 1756743
>>/dev/md1p1
>> =A0 =A0 =A0 =A0 Events : 1756737
>>/dev/md3p1
>> =A0 =A0 =A0 =A0 Events : 1756740
>>
>>And they don't seem to agree on the overall status of the array. The
>>ones that never went down seem to think the array is missing 4 nodes,
>>while the ones that went down seem to think all the nodes are good:
>>
>>for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdadm
>>-E $d | grep State; done
>>
>>/dev/sdc1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdd1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdf1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdh1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdj1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdk1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdl1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdm1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/sdn1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/md1p1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>/dev/md3p1
>> =A0 =A0 =A0 =A0 =A0State : clean
>> =A0 Array State : .A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing=
)
>>
>>So it seems like overall the array is intact, I just need to convince
>>it of that fact.
>>
>>> At that point, you should be able ro re-create the RAID. Be sure yo=
u list the drives in the correct order. Once the array is going again, =
mount the resulting partitions RO and verify that the data is o.k. befo=
re going RW.
>>
>>Could you be more specific about how exactly I should re-create the
>>RAID? Should I just do --assemble --force?
>
>
>
> =A0--> =A0No. As far as I know, you have to use "-C"/"--create". =A0Y=
ou need to use exactly the same array parameters that were used to crea=
te the array the first time. Same metadata version. Same stripe size. R=
aid mode the same. Physical devices in the same order.
>
> Why do you have to use "--create", and thus open the door for catastr=
opic error?? I have asked the same question myself. Maybe, if more peop=
le ping Neil Brown on this, he may be willing to find another way.
>
>
>
>>>
>>> Jim
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>> At 04:16 PM 9/17/2011, Mike Hartman wrote:
>>>>I should add that the mdadm command in question actually ends in
>>>>/dev/md0, not /dev/md3 (that's for another array). So the device na=
me
>>>>for the array I'm seeing in mdstat DOES match the one in the assemb=
le
>>>>command.
>>>>
>>>>On Sat, Sep 17, 2011 at 4:39 PM, Mike Hartman <mike@hartmanipulatio=
n.com> wrote:
>>>>> I have 11 drives in a RAID 6 array. 6 are plugged into one esata
>>>>> enclosure, the other 4 are in another. These esata cables are pro=
ne to
>>>>> loosening when I'm working on nearby hardware.
>>>>>
>>>>> If that happens and I start the host up, big chunks of the array =
are
>>>>> missing and things could get ugly. Thus I cooked up a custom star=
tup
>>>>> script that verifies each device is present before starting the a=
rray
>>>>> with
>>>>>
>>>>> mdadm --assemble --no-degraded -u 4fd7659f:12044eff:ba25240d:
>>>>> de22249d /dev/md3
>>>>>
>>>>> So I thought I was covered. In case something got unplugged I wou=
ld
>>>>> see the array failing to start at boot and I could shut down, fix=
 the
>>>>> cables and try again. However, I hit a new scenario today where o=
ne of
>>>>> the plugs was loosened while everything was turned on.
>>>>>
>>>>> The good news is that there should have been no activity on the a=
rray
>>>>> when this happened, particularly write activity. It's a big media
>>>>> partition and sees much less writing then reading. I'm also the o=
nly
>>>>> one that uses it and I know I wasn't transferring anything. The s=
ystem
>>>>> also seems to have immediately marked the filesystem read-only,
>>>>> because I discovered the issue when I went to write to it later a=
nd
>>>>> got a "read-only filesystem" error. So I believe the state of the
>>>>> drives should be the same - nothing should be out of sync.
>>>>>
>>>>> However, I shut the system down, fixed the cables and brought it =
back
>>>>> up. All the devices are detected by my script and it tries to sta=
rt
>>>>> the array with the command I posted above, but I've ended up with
>>>>> this:
>>>>>
>>>>> md0 : inactive sdn1[1](S) sdj1[9](S) sdm1[10](S) sdl1[11](S)
>>>>> sdk1[12](S) md3p1[8](S) sdc1[6](S) sdd1[5](S) md1p1[4](S) sdf1[3]=
(S)
>>>>> sdh1[0](S)
>>>>> =A0 =A0 =A0 16113893731 blocks super 1.2
>>>>>
>>>>> Instead of all coming back up, or still showing the unplugged dri=
ves
>>>>> missing, everything is a spare? I'm suitably disturbed.
>>>>>
>>>>> It seems to me that if the data on the drives still reflects the
>>>>> last-good data from the array (and since no writing was going on =
it
>>>>> should) then this is just a matter of some metadata getting messe=
d up
>>>>> and it should be fixable. Can someone please walk me through the
>>>>> commands to do that?
>>>>>
>>>>> Mike
>>>>>
>>>>--
>>>>To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>>>the body of a message to majordomo@vger.kernel.org
>>>>More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
