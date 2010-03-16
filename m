From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Tue, 16 Mar 2010 12:02:00 +0200
Message-ID: <4B9F5718.7030506@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com>	 <4B9ADC61.7080007@edu.physics.uoc.gr>	 <4B9AE28C.8030905@edu.physics.uoc.gr> <4877c76c1003121758w49cdeccas6865e65c9e985770@mail.gmail.com> <4B9B8DFC.30907@redhat.com> <4B9B90DB.4020809@edu.physics.uoc.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9B90DB.4020809@edu.physics.uoc.gr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Ric Wheeler <rwheeler@redhat.com>, davidsen@tmr.com
List-Id: linux-raid.ids

On 13/03/10 15:19, Kapetanakis Giannis wrote:

> I will try Fedora 12/64bit on Monday when I have physical access.
>
> Right now all tests have failed.
> OS in Centos 5.4 x86 PAE so I opened a ticket both in Centos and Redhat
> bugzilla.
> I don't have any contract with redhat but I hope they will give a try on
> this.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=573185
> http://bugs.centos.org/view.php?id=4239
>
> My feelings are that it has to do with the software raid layer and not
> the filesystem (ext4, xfs, gfs all died).
> The filesystem seems to not get the appropriate physical/logical
> quandaries from the raid layer.
>
> Unless the x86 kernel is not capable of addressing
> large filesystems as it is documented (16TB as you said).

I thought I should report here as well.

I've installed Centos 5.4 x64 and all going well so far.
No corruptions at all.

My setup is as before

sdb (hard raid5)
  |
  |------> md0 (soft raid0)----> LVM ----> ext4
  |
sdc (hard raid5)

The only strange thing I've noticed is that pvcreate
is messing with the gpt label on md0. Don't know of that
is normal.

https://bugzilla.redhat.com/show_bug.cgi?id=573185#c4

#fdisk -l /dev/md0

WARNING: GPT (GUID Partition Table) detected on '/dev/md0'! The util fdisk
doesn't support GPT. Use GNU Parted.


Disk /dev/md0: 14978.6 GB, 14978676948992 bytes
2 heads, 4 sectors/track, -638063744 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Disk /dev/md0 doesn't contain a valid partition table

# parted /dev/md0
GNU Parted 1.8.1
Using /dev/md0
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Error: Unable to open /dev/md0 - unrecognised disk label.

thanks all

Giannis
