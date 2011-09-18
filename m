From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Sat, 17 Sep 2011 21:34:29 -0400
Message-ID: <CAB=7dh=PymkpqRLTWiNzD-+n=XwEWnPN8nQwXg1=UmiJmZ1b1w@mail.gmail.com>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com>
	<CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com>
	<CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com>
	<20110918011749.98312581F7A@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110918011749.98312581F7A@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 17, 2011 at 9:16 PM, Jim Schatzman
<james.schatzman@futurelabusa.com> wrote:
> Mike-
>
> I have seen very similar problems. I regret that electronics engineer=
s cannot design more secure connectors. eSata connector are terrible - =
they come loose at the slightest tug. For this reason, I am gradually a=
bandoning eSata enclosures and going to internal drives only. Fortunate=
ly, there are some inexpensive RAID chassis available now.
>
> I tried the same thing as you. I removed the array(s) from mdadm.conf=
 and I wrote a script for "/etc/cron.reboot" which assembles the array,=
 "no-degraded". Doing this seems to minimize the damage caused by drive=
s prior to a reboot. However, if the drives are disconnected while Linu=
x is up, then either the array will stay up but some drives will become=
 stale or the array will be stopped. The behavior I usually see is that=
 all the drives that went offline now become "spare".
>

That sounds similar, although I only had 4/11 go offline and now
they're ALL spare.

> It would be nice if md would just reassemble the array once all the d=
rives come back online. Unfortunately, it doesn't. I would run mdadm -E=
 against all the drives/partitions, verifying that the metadata all ind=
icates that they are/were part of the expected array.

I ran mdadm -E and they all correctly appear as part of the array:

for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdadm
-E $d | grep Role; done

/dev/sdc1
   Device Role : Active device 5
/dev/sdd1
   Device Role : Active device 4
/dev/sdf1
   Device Role : Active device 2
/dev/sdh1
   Device Role : Active device 0
/dev/sdj1
   Device Role : Active device 10
/dev/sdk1
   Device Role : Active device 7
/dev/sdl1
   Device Role : Active device 8
/dev/sdm1
   Device Role : Active device 9
/dev/sdn1
   Device Role : Active device 1
/dev/md1p1
   Device Role : Active device 3
/dev/md3p1
   Device Role : Active device 6

But they have varying event counts (although all pretty close together)=
:

for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdadm
-E $d | grep Event; done

/dev/sdc1
         Events : 1756743
/dev/sdd1
         Events : 1756743
/dev/sdf1
         Events : 1756737
/dev/sdh1
         Events : 1756737
/dev/sdj1
         Events : 1756743
/dev/sdk1
         Events : 1756743
/dev/sdl1
         Events : 1756743
/dev/sdm1
         Events : 1756743
/dev/sdn1
         Events : 1756743
/dev/md1p1
         Events : 1756737
/dev/md3p1
         Events : 1756740

And they don't seem to agree on the overall status of the array. The
ones that never went down seem to think the array is missing 4 nodes,
while the ones that went down seem to think all the nodes are good:

for d in /dev/sd[cdfhjklmn]1 /dev/md1p1 /dev/md3p1; do echo $d; mdadm
-E $d | grep State; done

/dev/sdc1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf1
          State : clean
   Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh1
          State : clean
   Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdk1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdl1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdm1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdn1
          State : clean
   Array State : .A..AA.AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/md1p1
          State : clean
   Array State : AAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/md3p1
          State : clean
   Array State : .A..AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

So it seems like overall the array is intact, I just need to convince
it of that fact.

> At that point, you should be able ro re-create the RAID. Be sure you =
list the drives in the correct order. Once the array is going again, mo=
unt the resulting partitions RO and verify that the data is o.k. before=
 going RW.

Could you be more specific about how exactly I should re-create the
RAID? Should I just do --assemble --force?

>
> Jim
>
>
>
>
>
>
>
>
>
> At 04:16 PM 9/17/2011, Mike Hartman wrote:
>>I should add that the mdadm command in question actually ends in
>>/dev/md0, not /dev/md3 (that's for another array). So the device name
>>for the array I'm seeing in mdstat DOES match the one in the assemble
>>command.
>>
>>On Sat, Sep 17, 2011 at 4:39 PM, Mike Hartman <mike@hartmanipulation.=
com> wrote:
>>> I have 11 drives in a RAID 6 array. 6 are plugged into one esata
>>> enclosure, the other 4 are in another. These esata cables are prone=
 to
>>> loosening when I'm working on nearby hardware.
>>>
>>> If that happens and I start the host up, big chunks of the array ar=
e
>>> missing and things could get ugly. Thus I cooked up a custom startu=
p
>>> script that verifies each device is present before starting the arr=
ay
>>> with
>>>
>>> mdadm --assemble --no-degraded -u 4fd7659f:12044eff:ba25240d:
>>> de22249d /dev/md3
>>>
>>> So I thought I was covered. In case something got unplugged I would
>>> see the array failing to start at boot and I could shut down, fix t=
he
>>> cables and try again. However, I hit a new scenario today where one=
 of
>>> the plugs was loosened while everything was turned on.
>>>
>>> The good news is that there should have been no activity on the arr=
ay
>>> when this happened, particularly write activity. It's a big media
>>> partition and sees much less writing then reading. I'm also the onl=
y
>>> one that uses it and I know I wasn't transferring anything. The sys=
tem
>>> also seems to have immediately marked the filesystem read-only,
>>> because I discovered the issue when I went to write to it later and
>>> got a "read-only filesystem" error. So I believe the state of the
>>> drives should be the same - nothing should be out of sync.
>>>
>>> However, I shut the system down, fixed the cables and brought it ba=
ck
>>> up. All the devices are detected by my script and it tries to start
>>> the array with the command I posted above, but I've ended up with
>>> this:
>>>
>>> md0 : inactive sdn1[1](S) sdj1[9](S) sdm1[10](S) sdl1[11](S)
>>> sdk1[12](S) md3p1[8](S) sdc1[6](S) sdd1[5](S) md1p1[4](S) sdf1[3](S=
)
>>> sdh1[0](S)
>>> =A0 =A0 =A0 16113893731 blocks super 1.2
>>>
>>> Instead of all coming back up, or still showing the unplugged drive=
s
>>> missing, everything is a spare? I'm suitably disturbed.
>>>
>>> It seems to me that if the data on the drives still reflects the
>>> last-good data from the array (and since no writing was going on it
>>> should) then this is just a matter of some metadata getting messed =
up
>>> and it should be fixable. Can someone please walk me through the
>>> commands to do that?
>>>
>>> Mike
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
