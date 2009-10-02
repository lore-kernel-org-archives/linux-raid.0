From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 07:54:04 -0700
Message-ID: <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
	<887103.5263.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <887103.5263.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: chimera_god@yahoo.com, keld@dkuug.dk, robin@robinhill.me.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everybody,

2009/10/2 Keld J=F8rn Simonsen <keld@dkuug.dk>:
> You can boot from a raid-10,n2 with the superblock last, standard
> raid10,n2 will do. But the normal thing is to boot from raid-1
>
> There is a description of a setup at
> http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_dis=
k

Thanks for the URL.  Is there a reason that raid-1 is the "normal
thing"? Just popularity or something technical?

In your reference it says "The root file system can be on another raid
than the /boot partition. We recommend an raid10,f2, as the root file
system will mostly be reads, and the raid10,f2 raid type is the
fastest for reads, while also sufficiently fast for writes. Other
relevant raid types would be raid10,o2 or raid1." and "a small /boot
partition. We recommend something like 200 MB on an ext3 raid1".

How or why did you arrive at "raid-10,n2 with the superblock last"?

On Fri, Oct 2, 2009 at 12:54 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> With OpenSUSE you can just switch to the second console at that point=
 of

I didn't know about the console switching option, thanks.  I'll look
for docs on how to switch; I guess a F-key does the trick.  As far as
you know, even though the graphical installers don't offer RAID-10
config as an option, are they RAID-10 aware enough to correctly
recognize/identify the array as RAID-10 after manual setup then
rescan?

SystemRescueCD approach still seems straightforward too, and can be
doc'd as doable across any OS install.

On Fri, Oct 2, 2009 at 5:30 AM, adfas asd <chimera_god@yahoo.com> wrote=
:
> I am booting just fine from a RAID10-o2 array, although I'm told I'm =
not supposed to.

Why "not supposed to"?  Is it the RAID 10? or the 'o2' that's the probl=
em?

>I've unplugged each drive and tried it, and they boot just fine degrad=
ed.

That's great to hear.  Just curious, how many drives in your array at t=
he time?

> I followed this guide, to convert my -running- Debian system, and jus=
t made a few substitutions for RAID10:
> http://www.howtoforge.com/software-raid1-grub-boot-debian-etch

Thanks for the additional URL.

In all these cases /boot on RAID-10 was on its own partition, NOT on
/boot in a LVM-on-RAID, right?

Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
