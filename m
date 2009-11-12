From: Luca Berra <bluca@comedia.it>
Subject: Re: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Thu, 12 Nov 2009 08:52:03 +0100
Message-ID: <20091112075203.GA22315@maude.comedia.it>
References: <4AF9F415.9050809@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AF9F415.9050809@ribosome.natur.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Martin =?iso-8859-2?Q?MOKREJ=A9?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 11, 2009 at 12:15:33AM +0100, Martin MOKREJ=A9 wrote:
>Hi,
>  after poking around the internet I cannot answer myself several ques=
tions.
>Please somebody feel free to update the http://linux-raid.osdl.org/ pa=
ges
>and the mdadm manpage to explain the differences. ;-)
i don't believe information about bios settings of a particular
controller belongs in mdadm man page

>  1. Does the BIOS values, especially AHCI vs. RAID force for example =
the
>ICH9R chip into different mode seen by linux kernel? Looks like that .=
=2E.
iirc changing the settings from SATA to AHCI or RAID changes the pci id
for the controler, and the kernel driver is different.
I am not sure if changing between AHCI and RAID really matters to the
linux kernel.
>I have two machines and see there is a difference reported. Could that
>cause machine instability if the disks would be configured through mda=
dm
>to be in RAID? Some kind of conflict?
no, not the bios (AHCI vs RAID) settings, it would if you configured an
array from the controller bios, then used mdadm with a normal metadata
format
>
>  2. Selecting RAID mode in BIOS writes some Intel Storage Matrix labe=
l
>somewhere into the disk, right? I think I read in mdadm manpage or sim=
ilar about
no, that something is written only if you configure an array.

>"imsm" superblock format or something like that ... supported by mdrai=
d. I cannot
>find it anymore. Does it mean that one could force mdadm to create the=
 superblock
>recognized by the ICH9R BIOS and in theory MS Win drivers from Intel?
badly expressed but in short yes,
please read
http://neil.brown.name/git?p=3Dmdadm;a=3Dblob_plain;f=3DANNOUNCE-3.0

>  3. I have now 0.90 superblocks on two raid1 disc partitions /dev/sd[=
a-b]1.
>What happens if I go to BIOS of ICH9R and "remove the drives from the =
raid1" array?
So you _did_ create an array in the controller bios, and at point 1 and=
 2
you were giving misleading information?

>Does that clear the "imsm?" superblock? Will that kill the 0.90 mdadm =
superblock
>and destroy my linux mdraid?
it should clear the imsm metadata from the disk
it should not touch the md metadata
BUT, since the imsm metadata lies somewhere on your disk and you never
told linux about it there is the possibility that some data was
allocated in the same place, sorry.

>  4. There is hardly a documentation available comparing and explainin=
g
>the difference between dmraid and mdraid. My understanding is that dmr=
aid
this is a common problem nowadays, there is a lot of documentation abou=
t
many topics, but you never find which documentation is relevant to you
:(

>is used in linux/win dual-boot machines and is older implementation. D=
oes
>use of the "imsm" superblock format under mdadm give the same possibil=
ity?
not exactly
as there are many other examples in the open source world you find more
than one software for a similar purpose, neither obsoletes the other.

md was invented to provide software raid to linux well before fakeraids
(and device-mapper) where invented. It used its own metadata format.
It also implement its own kernel code for doing raid stuff.
Recently Neil and others added support for managing metadata in DDF
(and IMSM) format.

When fakeraids first appeared some (few) vendors used to provide a
closed-source binary only linux module to support their raid format.
These mostly sucked. other vendors just did not care about lee-nuks.
with the advent of the 2.6 kernel and adoption of device-mapper in
mainline Heinz created dmraid
dmraid is able to read the metadata format of many fakeraid cards, not
just intel's, and will use device-mapper modules to do raid stuff.
device-mapper already add support for linear, striping and mirror, late=
r
heinz added raid5.
It surely was most useful for dual boot, since it never supported
diagnostics or rebuild features you expect from a raid software, but in
some case the benefit of being able to boot when the first drive failed
outweighted that.
Recently dmraid also supports rebuild and management features, at least
with intel controlers.

so we have two implementations, they both are functioning and
maintained, and they both work in your case.
which one to use is a matter of personal preference.

btw, from time to time there is talk of merging portion of the md raid
code with the device-mapper raid code. It has not happened yet.


L.



--=20
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
