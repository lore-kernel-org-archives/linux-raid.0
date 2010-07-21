From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Missing Drives
Date: Tue, 20 Jul 2010 18:23:40 -0700
Message-ID: <AANLkTikLzfbun7EfCIk9LFoi62izCPZqvVD4vigjrn7g@mail.gmail.com>
References: <201007210129.41566.james@howells.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201007210129.41566.james@howells.uk.net>
Sender: linux-raid-owner@vger.kernel.org
To: james@howells.uk.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 20, 2010 at 5:29 PM, James Howells <james@howells.uk.net> w=
rote:
> Hi everyone.
>
> Fantastic job with the Linux mdadm tool but I've got a problem that I=
 need
> some support with.
>
> (Before you all ask, I've Googled this one to death, so please don't =
think of
> me as ignorant and blind).
>
> Basically, I have a 5 disk RAID-5 array in an Addonics external enclo=
sure.
> Each disk is 1TB in size. Since I am running it over USB, it's takes =
3-3.5
> days to resync the disks if something goes pear-shaped.
>
> Now, I don't think the software is at fault because I've had the driv=
e
> replaced with a brand new disk and it's doing the exact same thing -
> drive /dev/sde loses it's partition data (the drive's superblock) and=
 the md
> device's superblock. The data is unaffected since I only ever mount t=
he
> device as read-only unless I need RW capability. I physically power t=
he
> device down after unmounting the partition and stopping the array.
>
> Whilst other people have had this problem of drives suddenly "losing
> everything", they have been able to recover, but I cannot keep my com=
puter
> running for 3-3.5 days just to rebuild good data!
>
> My question is:
>
> Is it possible to copy the md superblock from one known good drive to=
 another
> and assemble it as forced-clean?
>
> It's easy enough to recreate the partition table with a simple:
>
> dd if=3D/dev/sda of=3D/dev/sde count=3D1 bs=3D512
>
> command but I believe the mdadm superblock lives at the end of the dr=
ive and
> if I could recreate that then I could at least recover from a failure=
 of a
> known-good drive without needing a resync.
>
> I'm looking into getting the RAID controller card (actually an eSATA =
5-1 mini
> card) replaced or repaired but in the meantime, I am exploring all av=
enues.
>
> This only happens on /dev/sde and not on any other device. Swapping h=
ard
> drives around doesn't make any difference either - /dev/sde is perfec=
tly
> readable. Clearly, though, I am not happy about building an array wit=
h a
> drive in that "cursed" slot since the loss of another drive in a RAID=
-5 would
> destroy everything stored on the array.
>
> Any advice would be gratefully appreciated.
>
> Regards,
>
> James
>
> PS. I'm running Debian Lenny 2.6.26-2-686 32-bit kernel with mdadm ve=
rsion
> 2.6.7.2-3 (repackaged for Debian).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

James,
   Search the LKML for my thread "Drives missing at boot" to see if
you have a problem similar to the one Paul and I have had. If so there
is a kernel patch in the thread which addresses the issue and seems to
work. We both have Asus MBs, new, fast i7 9xx processors, and ran into
this problem.

   In my case drives that were found at boot always continues to work.
The problem I had was they go missing at boot time and then I'd have
to add them back in and do rebuilds, 5 a week at times.

   Anyway, I hope it helps. If not good luck in your search.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
