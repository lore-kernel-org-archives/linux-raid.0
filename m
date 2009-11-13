From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Fri, 13 Nov 2009 15:46:19 -0700
Message-ID: <e9c3a7c20911131446l1b18ae69l6f9d40126641b87@mail.gmail.com>
References: <4AF9F415.9050809@ribosome.natur.cuni.cz>
	 <20091112075203.GA22315@maude.comedia.it>
	 <4AFC3299.3040702@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFC3299.3040702@ribosome.natur.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Martin_MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Nov 12, 2009 at 9:06 AM, Martin MOKREJ=C5=A0
<mmokrejs@ribosome.natur.cuni.cz> wrote:
> Hi everybody,
>
> Luca Berra wrote:
>> On Wed, Nov 11, 2009 at 12:15:33AM +0100, Martin MOKREJ=C5=A0 wrote:
>>> Hi,
>>> =C2=A0after poking around the internet I cannot answer myself sever=
al
>>> questions.
>>> Please somebody feel free to update the http://linux-raid.osdl.org/=
 pages
>>> and the mdadm manpage to explain the differences. ;-)
>>
>> i don't believe information about bios settings of a particular
>> controller belongs in mdadm man page
>
> I agree but some clarification what is relation to these fakeraids,
> changes in behavior would be helpful. If do not have =C2=A0a problem =
if the
> information appears on the website (probably related tot this email l=
ist?).

To Linux:

IDE =3D=3D ata_piix
AHCI =3D ahci
RAID =3D=3D ahci

>
>>
>>> =C2=A01. Does the BIOS values, especially AHCI vs. RAID force for e=
xample the
>>> ICH9R chip into different mode seen by linux kernel? Looks like tha=
t ...
>>
>> iirc changing the settings from SATA to AHCI or RAID changes the pci=
 id
>> for the controler, and the kernel driver is different.
>> I am not sure if changing between AHCI and RAID really matters to th=
e
>> linux kernel.
>
> There are IDE/AHCI/RAID values.

It changes the pci-id, but protocol-wise it is still AHCI.

>
>>> I have two machines and see there is a difference reported. Could t=
hat
>>> cause machine instability if the disks would be configured through =
mdadm
>>> to be in RAID? Some kind of conflict?
>>
>> no, not the bios (AHCI vs RAID) settings, it would if you configured=
 an
>> array from the controller bios, then used mdadm with a normal metada=
ta
>> format
>
> That is what happened to me. Two disks are not in an ICH9R array but =
are
> in raid0 under mdadm. Four disk are under raid10 under ICH9R while al=
so
> under raid10 under mdadm.

You can use mdadm-3.x to remove whatever superblock you don't need i.e:

mdadm --zero-superblock -e imsm /dev/sdX
-or-
mdadm --zero-superblock -e 0.90 /dev/sdX
etc...

>
> I observe random lockup for a year or so, either "Aiee, killing inter=
rupt handler",
> or black screen on console and flashing LED diodes on the keyboard. H=
owever,
> the issues are more common since I upgraded to glibc-10. I tried vari=
ous
> kernels, from 2.6.27.38 to 2.6.30.9. Basically I suspect misconfigura=
tion
> issue rather then a real hardware issue. I think it is related to hea=
vy IO
> and indeed last week I crashed the machine few times after upgrading =
some
> packages which caues lots of reads in $raid10fs/usr/portage tree (Gen=
too Linux).
>

At first glance this does not sound like a RAID problem, but would
need more information about what is going on around the lockup,
certainly not caused by switching between RAID mode and AHCI mode.

>>> =C2=A02. Selecting RAID mode in BIOS writes some Intel Storage Matr=
ix label
>>> somewhere into the disk, right? I think I read in mdadm manpage or
>>> similar about
>> no, that something is written only if you configure an array.

Correct, nothing is written to the disks until you create an array.

>
> That I mistakenly left in some years ago.
>
>>
>>> "imsm" superblock format or something like that ... supported by
>>> mdraid. I cannot
>>> find it anymore. Does it mean that one could force mdadm to create =
the
>>> superblock
>>> recognized by the ICH9R BIOS and in theory MS Win drivers from Inte=
l?
>> badly expressed but in short yes,
>> please read
>> http://neil.brown.name/git?p=3Dmdadm;a=3Dblob_plain;f=3DANNOUNCE-3.0
>
> Ah, thanks for the pointer. I have the impression that the new contai=
ners do
> not replace superblocks. I will try tro re-phrase it: one will not ha=
ve "imsm"
> superblock but drives with 0.9, 1.0, 1.2 can be parts of an "imsm" co=
ntainer,

No.  The metadata is completely separate.  Have a look at the man page
for mdmon in a 3.x mdadm release for a better explanation of
containers.  And please send any detailed questions you have about
that documentation so that we can make it better.

> written somewhere around. I wonder whether such setup would be a safe=
 approach
> for me so in a way that I would not have to bother whether I have lef=
t in BIOS
> settings not only RAID or AHCI value but even a configured array. My =
understanding
> is these "fake-raids" just define what the array is and linux/win dri=
vers have
> to do the job, so the BIOS stuff only means that one can define what =
needs to be
> done.

It is more than that.  The benefit of RAID mode is that it enables the
platform's option-ROM to allow booting from any supported raid level,
and configuring RAID volumes pre-OS.

> What is still of interest to me whether the RAID or AHCI mode is pref=
erred for
> mdraid user although one should avoid defining the array through the =
"fake-raid"
> chip. The previous answer from Majed B. unfortunately only points tha=
t AHCI mode
> is faster than IDE mode.

You pretty much always want AHCI mode as it has features like hotplug
and better performance.  RAID mode is useful if you want to the use
the option-ROM for booting and RAID configuration.

>>
>>> =C2=A03. I have now 0.90 superblocks on two raid1 disc partitions
>>> /dev/sd[a-b]1.
>>> What happens if I go to BIOS of ICH9R and "remove the drives from t=
he
>>> raid1" array?
>>
>> So you _did_ create an array in the controller bios, and at point 1 =
and 2
>> you were giving misleading information?
>
> Yes, see above

This will delete the Intel metadata which is located at the end of the =
disk.

>>> Does that clear the "imsm?" superblock? Will that kill the 0.90 mda=
dm
>>> superblock and destroy my linux mdraid?
>> it should clear the imsm metadata from the disk
>>
>> it should not touch the md metadata
>> BUT, since the imsm metadata lies somewhere on your disk and you nev=
er
>> told linux about it there is the possibility that some data was
>> allocated in the same place, sorry.
>
> So best way out is to set ICH9R to AHCI, migrate the data, switch ICH=
9R tp RAID,
> delete the RAID10 array, switch ICH9R to AHCI, create new array under=
 mdadm?

The Intel metadata is at the end of drive and technically overlaps the
space for the 0.90 format.  The good news is that 0.90 starts at a 4K
offset from the end and grows down while the Intel format starts at
the second to last sector and grows up, so if any collision were to
occur it would have already happened.  To be safe I would backup the
data on the 0.90 array delete both superblocks and restore (the BIOS
setting is a don't care for this procedure).  When you restore choose
between native md metadata or 'imsm', not both :-).  If you choose
'imsm' and want to use the option-ROM's boot-from-raid functionality
select RAID mode otherwise AHCI is sufficient.

>>> =C2=A04. There is hardly a documentation available comparing and ex=
plaining
>>> the difference between dmraid and mdraid.

Maturity, metadata management, raid4/5/6, raid level migrations, and
capacity expansion.

http://thread.gmane.org/gmane.linux.raid/23034

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
