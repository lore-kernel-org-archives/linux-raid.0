From: EJ Vincent <ej@ejane.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Mon, 01 Oct 2012 23:53:08 -0400
Message-ID: <506A6524.1030202@ejane.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org> <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com> <50689C9B.1010603@ejane.org> <5068AB81.1060103@turmel.org> <5068D464.4030504@ejane.org> <20121002121520.362564ef@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121002121520.362564ef@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/1/2012 10:15 PM, NeilBrown wrote:
> On Sun, 30 Sep 2012 19:23:16 -0400 EJ Vincent <ej@ejane.org> wrote:
>
>> On 9/30/2012 4:28 PM, Phil Turmel wrote:
>>> On 09/30/2012 03:25 PM, EJ Vincent wrote:
>>>> On 9/30/2012 3:22 PM, Mathias Bur=C3=A9n wrote:
>>>>> Can't you just boot off an older Ubuntu USB, install mdadm and sc=
an /
>>>>> assemble, see the device order?
>>>> Hi Mathias,
>>>>
>>>> I'm under the impression that damage to the metadata has already b=
een
>>>> done by 12.04, making a recovery from an older version of Ubuntu
>>>> (10.04), impossible.  Is this line of thinking, flawed?
>>> Your impression is correct.  Permanent damage to the metadata was d=
one.
>>>    You *must* re-create your array.
>>>
>>> However, you *cannot* use your new version of mdadm, as it will get=
 the
>>> data offset wrong.  Your first report showed a data offset of 272.
>>> Newer versions of mdadm default to 2048.  You *must* perform all of=
 your
>>> "mdadm --create --assume-clean" permutations with 10.04.
>>>
>>> Do you have *any* dmesg output from the old system?  Or dmesg from =
the
>>> very first boot under 12.04?  That might have enough information to
>>> shorten your search.
>>>
>>> In the future, you should record your setup by saving the output of
>>> "mdadm -D" on each array, "mdadm -E" on each member device, and the
>>> output of "ls -l /dev/disk/by-id/"
>>>
>>> Or try my documentation script "lsdrv". [1]
>>>
>>> HTH,
>>>
>>> Phil
>>>
>>> [1] http://github.com/pturmel/lsdrv
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Hi Phil,
>>
>> Unfortunately I don't have any dmesg log from the old system or the
>> first boot under 12.04.
>>
>> Getting my system to boot at all under 12.04 was chaotic enough, wit=
h
>> the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-funct=
ions
>> ravaging my array and then dropping me to a busybox shell over and o=
ver
>> again.  I didn't think to record the very first error.
>>
>> Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and
>> /dev/sdj1 don't have the Raid level "-unknown-", neither are they
>> labeled as spares.  They are in fact, labeled clean and appear
>> *different* from the others.
>>
>> Could these disks still contain my metadata from 10.04?  I recall du=
ring
>> my installation of 12.04 I had anywhere from 1 to 3 disks unpowered,=
 so
>> that I could drop in a SATA CD/DVDRW into the slot.
>>
>> I am downloading 10.04.4 LTS and will be ready to use it soon.  I fe=
ar
>> having to do permutations-- 9! (factorial) would mean 362,880
>> combinations.  *gasp*
> You might be able to avoid the 9! combinations, which could take a wh=
ile ...
> 4 days if you could test one per second.
>
> Try this:
>
>   for i in /dev/sd?1; do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=3D=
1 count=3D4 \
>      skip=3D4256 | od -D | head -n1; done
>
> This reads that 'dev_number' fields out of the metadata on each devic=
e.
> This should not have been corrupted by the bug.
> You might want some other pattern in place of "/dev/sd?1" - it needs =
to match
> all the devices in your array.
>
> Then on one of the devices which doesn't have corrupted metadata, run
>
>    dd 2> /dev/null if=3D/dev/sdXXX1 bs=3D2 count=3D$COUNT skip=3D2176=
 | od -d
>
> where $COUNT is one more than the largest number that was reported in=
 the
> "dev_number" values reported above.
>
> Now for each device, take the dev_number that was reported, use that =
as an
> index into the list of numbers produced by the second command, and th=
at
> number if the role of the device in the array.  i.e. it's position in=
 the
> list.
>
> So after making an array of 5 'loop' devices in a non-obvious order, =
and
> failing a device and re-adding it:
>
> # for i in /dev/loop[01234]; do echo -n $i '' ; dd 2> /dev/null if=3D=
$i bs=3D1 count=3D4 skip=3D4256 | od -D | head -n1; done
> /dev/loop0 0000000          3
> /dev/loop1 0000000          4
> /dev/loop2 0000000          1
> /dev/loop3 0000000          0
> /dev/loop4 0000000          5
>
> and
>
> # dd 2> /dev/null if=3D/dev/loop0 bs=3D2 count=3D6 skip=3D2176 | od -=
d
> 0000000     0     1 65534     3     4     2
> 0000014
>
> So /dev/loop0 has dev_number '3'. Look for entry '3' in the list and =
get '3'
> /dev/loop1 has 'dev_number' 4, so is device 4
> /dev/loop4 has dev_number '5', so is device 2
> etc
> So we can reconstruct the order of devices:
>
>   /dev/loop3 /dev/loop2 /dev/loop4 /dev/loop0 /dev/loop1
>
> Note the '65534' in the list means that there is no device with that
> dev_number.  i.e. no device is number '2', and looking at the list co=
nfirms
> that.
>
> You should be able to perform the same steps to recover the correct o=
rder to
> try creating the array.
>
> NeilBrown
>


Hi Neil,

Thank you so much for taking the time to help me through this.

Here's what I've come up with, per your instructions:

/dev/sda1 0000000          4
/dev/sdb1 0000000         11
/dev/sdc1 0000000          7
/dev/sde1 0000000          8
/dev/sdf1 0000000          1
/dev/sdg1 0000000          0
/dev/sdh1 0000000          6
/dev/sdi1 0000000         10
/dev/sdj1 0000000          9

dd 2> /dev/null if=3D/dev/sdc1 bs=3D2 count=3D12 skip=3D2176 | od -d
0000000     0     1 65534 65534     2 65534     4     5
0000020     6     7     8     3
0000030

Mind doing a sanity check for me?

Based on the above information, one such possible device order is:

/dev/sdg1 /dev/sdf1 /dev/sdb1* /dev/sdi1* /dev/sda1 /dev/sdj1* /dev/sdh=
1=20
/dev/sdc1 /dev/sde1

where * represents the three unknown devices marked by 65534?

Once I have your blessing, would I then proceed to:

mdadm --create /dev/md0 --assume-clean --level=3D6 --raid-devices=3D9=20
--metadata=3D1.2 --chunk=3D512 /dev/sdg1 /dev/sdf1 /dev/sdb1* /dev/sdi1=
*=20
/dev/sda1 /dev/sdj1* /dev/sdh1 /dev/sdc1 /dev/sde1

and this is non-destructive, so I can attempt different orders?

Again, thank you for the help.

Best wishes,

-EJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
