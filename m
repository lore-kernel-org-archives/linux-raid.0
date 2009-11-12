From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Thu, 12 Nov 2009 17:06:49 +0100
Message-ID: <4AFC3299.3040702@ribosome.natur.cuni.cz>
References: <4AF9F415.9050809@ribosome.natur.cuni.cz> <20091112075203.GA22315@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091112075203.GA22315@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi everybody,

Luca Berra wrote:
> On Wed, Nov 11, 2009 at 12:15:33AM +0100, Martin MOKREJ=C5=A0 wrote:
>> Hi,
>>  after poking around the internet I cannot answer myself several
>> questions.
>> Please somebody feel free to update the http://linux-raid.osdl.org/ =
pages
>> and the mdadm manpage to explain the differences. ;-)
>
> i don't believe information about bios settings of a particular
> controller belongs in mdadm man page

I agree but some clarification what is relation to these fakeraids,
changes in behavior would be helpful. If do not have  a problem if the
information appears on the website (probably related tot this email lis=
t?).

>=20
>>  1. Does the BIOS values, especially AHCI vs. RAID force for example=
 the
>> ICH9R chip into different mode seen by linux kernel? Looks like that=
 ...
>
> iirc changing the settings from SATA to AHCI or RAID changes the pci =
id
> for the controler, and the kernel driver is different.
> I am not sure if changing between AHCI and RAID really matters to the
> linux kernel.

There are IDE/AHCI/RAID values.

>> I have two machines and see there is a difference reported. Could th=
at
>> cause machine instability if the disks would be configured through m=
dadm
>> to be in RAID? Some kind of conflict?
>
> no, not the bios (AHCI vs RAID) settings, it would if you configured =
an
> array from the controller bios, then used mdadm with a normal metadat=
a
> format

That is what happened to me. Two disks are not in an ICH9R array but ar=
e
in raid0 under mdadm. Four disk are under raid10 under ICH9R while also
under raid10 under mdadm.

I observe random lockup for a year or so, either "Aiee, killing interru=
pt handler",
or black screen on console and flashing LED diodes on the keyboard. How=
ever,
the issues are more common since I upgraded to glibc-10. I tried variou=
s
kernels, from 2.6.27.38 to 2.6.30.9. Basically I suspect misconfigurati=
on
issue rather then a real hardware issue. I think it is related to heavy=
 IO
and indeed last week I crashed the machine few times after upgrading so=
me
packages which caues lots of reads in $raid10fs/usr/portage tree (Gento=
o Linux).

>>
>>  2. Selecting RAID mode in BIOS writes some Intel Storage Matrix lab=
el
>> somewhere into the disk, right? I think I read in mdadm manpage or
>> similar about
> no, that something is written only if you configure an array.

That I mistakenly left in some years ago.

>=20
>> "imsm" superblock format or something like that ... supported by
>> mdraid. I cannot
>> find it anymore. Does it mean that one could force mdadm to create t=
he
>> superblock
>> recognized by the ICH9R BIOS and in theory MS Win drivers from Intel=
?
> badly expressed but in short yes,
> please read
> http://neil.brown.name/git?p=3Dmdadm;a=3Dblob_plain;f=3DANNOUNCE-3.0

Ah, thanks for the pointer. I have the impression that the new containe=
rs do
not replace superblocks. I will try tro re-phrase it: one will not have=
 "imsm"
superblock but drives with 0.9, 1.0, 1.2 can be parts of an "imsm" cont=
ainer,
written somewhere around. I wonder whether such setup would be a safe a=
pproach
for me so in a way that I would not have to bother whether I have left =
in BIOS
settings not only RAID or AHCI value but even a configured array. My un=
derstanding
is these "fake-raids" just define what the array is and linux/win drive=
rs have
to do the job, so the BIOS stuff only means that one can define what ne=
eds to be
done.

What is still of interest to me whether the RAID or AHCI mode is prefer=
red for
mdraid user although one should avoid defining the array through the "f=
ake-raid"
chip. The previous answer from Majed B. unfortunately only points that =
AHCI mode
is faster than IDE mode.


>=20
>>  3. I have now 0.90 superblocks on two raid1 disc partitions
>> /dev/sd[a-b]1.
>> What happens if I go to BIOS of ICH9R and "remove the drives from th=
e
>> raid1" array?
>
> So you _did_ create an array in the controller bios, and at point 1 a=
nd 2
> you were giving misleading information?

Yes, see above.

>=20
>> Does that clear the "imsm?" superblock? Will that kill the 0.90 mdad=
m
>> superblock and destroy my linux mdraid?
> it should clear the imsm metadata from the disk
>
> it should not touch the md metadata
> BUT, since the imsm metadata lies somewhere on your disk and you neve=
r
> told linux about it there is the possibility that some data was
> allocated in the same place, sorry.

So best way out is to set ICH9R to AHCI, migrate the data, switch ICH9R=
 tp RAID,
delete the RAID10 array, switch ICH9R to AHCI, create new array under m=
dadm?

>=20
>>  4. There is hardly a documentation available comparing and explaini=
ng
>> the difference between dmraid and mdraid. My understanding is that d=
mraid
>
> this is a common problem nowadays, there is a lot of documentation ab=
out
> many topics, but you never find which documentation is relevant to yo=
u
> :(
>=20
>> is used in linux/win dual-boot machines and is older implementation.=
 Does
>> use of the "imsm" superblock format under mdadm give the same
>> possibility?
>
> not exactly
> as there are many other examples in the open source world you find mo=
re
> than one software for a similar purpose, neither obsoletes the other.
>=20
> md was invented to provide software raid to linux well before fakerai=
ds
> (and device-mapper) where invented. It used its own metadata format.
> It also implement its own kernel code for doing raid stuff.
> Recently Neil and others added support for managing metadata in DDF
> (and IMSM) format.
>=20
> When fakeraids first appeared some (few) vendors used to provide a
> closed-source binary only linux module to support their raid format.
> These mostly sucked. other vendors just did not care about lee-nuks.
> with the advent of the 2.6 kernel and adoption of device-mapper in
> mainline Heinz created dmraid
> dmraid is able to read the metadata format of many fakeraid cards, no=
t
> just intel's, and will use device-mapper modules to do raid stuff.
> device-mapper already add support for linear, striping and mirror, la=
ter
> heinz added raid5.
> It surely was most useful for dual boot, since it never supported
> diagnostics or rebuild features you expect from a raid software, but =
in
> some case the benefit of being able to boot when the first drive fail=
ed
> outweighted that.
> Recently dmraid also supports rebuild and management features, at lea=
st
> with intel controlers.
>=20
> so we have two implementations, they both are functioning and
> maintained, and they both work in your case.
> which one to use is a matter of personal preference.

Or the Install guide one finds first. ;-)

>=20
> btw, from time to time there is talk of merging portion of the md rai=
d
> code with the device-mapper raid code. It has not happened yet.

Yeah, that I found by Google.

Thank you,
M.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
