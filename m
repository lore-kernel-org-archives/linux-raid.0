From: Guillaume Paumier <guillaume.paumier@gmail.com>
Subject: Re: Guidance on reshape stuck at 0% after --grow
Date: Sat, 26 Sep 2015 17:59:36 -0700
Message-ID: <CAKWBTuFTANRTWP692hf9Et_8GPvx=uLvYowKRCLdhQPMqhCKKg@mail.gmail.com>
References: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
	<alpine.DEB.2.02.1509221224470.8750@uplift.swm.pp.se>
	<CAKWBTuG2AngM6joiODt15Qe+HAXfF6OnJVD-HNuNKikfyv-6MQ@mail.gmail.com>
	<5602EB5E.6010703@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5602EB5E.6010703@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

On 23 September 2015 at 11:11, Wols Lists <antlists@youngman.org.uk> wrote:
>
> Read up on loopback devices. Sorry, never done it, can't help
> personally, but it sticks a ram-disk layer between mdadm and the actual
> disk.
>
> So the disks themselves are read-only, and you can try things out to see
> what works. If it fails, you throw the loopback layer away, if it works
> you can run it on the disk itself.

Thank you; that seems similar to what is described at
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
, and was also suggested in
http://www.spinics.net/lists/raid/msg49669.html

It seems I'm running into another issue, described at the bottom of
https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29
:

"If upon running the above with the --size parameter you get, as one
of the authors of this page did, an error such as: "mdadm: /dev/sdb1
is smaller than given size. xxxK < yyyK + metadata", you may have
stumbled upon a problem where the array was initially created with an
earlier version of mdadm that reserved less device space. The solution
seems to be to find an earlier version of mdadm to run with the
creation command above"

This seems consistent with the errors I'm getting, in the form:
mdadm: /dev/sdc1 is smaller than given size. 3906885632K < 3907016448K
+ metadata

I found the list of previous versions of mdadm at
https://www.kernel.org/pub/linux/utils/raid/mdadm/ , but I'm not sure
which one to pick, and how easy it is to use those earlier versions.
According to my logs, I originally created the array in late July
2013. I'm not afraid of compiling it from source, but any additional
information would be helpful.

-- 
Guillaume Paumier
