From: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 08 Mar 2005 11:51:29 +0100
Message-ID: <422D83B1.5060709@medien.uni-weimar.de>
References: <422D327D.11718.F8DB3@localhost>	 <200503080414.j284EG510309@www.watkins-home.com>	 <16941.11443.107607.735855@cse.unsw.edu.au>	 <62b0912f0503072120776e0b56@mail.gmail.com>	 <16941.14813.465306.72004@cse.unsw.edu.au>	 <62b0912f05030721465e84e4da@mail.gmail.com>	 <16941.16439.595486.231598@cse.unsw.edu.au>	 <62b0912f050307222494fe17f@mail.gmail.com>	 <422D625C.5020803@medien.uni-weimar.de> <62b0912f0503080057488f13ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f0503080057488f13ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Molle Bestefich <molle.bestefich@gmail.com>
List-Id: linux-raid.ids

On 08.03.2005 09:57, Molle Bestefich wrote:

[...]

> I'm gonna CC the list anyway, hope it's okay :-).

I hope so, too... ;)

[...]

> No, but I can tell you what I did.
> 
> I stuffed a bunch of cheap SATA disks and crappy controllers in an old system.
> (And replaced the power supply with one that has enough power on the 12V rail.)
> 
> It's running 2.4, and since it's IDE disks, I just call 'hdparm
> -S<whatever>' in rc.local,
> which instructs the disks to go on standby whenever they've been idle
> for 10 minutes.

I had found postings on the net claiming that doing so without 
unmounting the fs on the raid, this would lead to bad things happening - 
  but your report seems to prove them wrong...

> Works like a charm so far, been running for a couple of years.
> There does not seem to be any issues with MD and timing because of the
> disks using 5 seconds or so to spin up, MD happily waits for them, and
> no corruption or wrong behaviour has stemmed from putting the disks in
> sleep mode.

Good to read - will test that once I have the raid free to fool around 
with, thanks for the info! :)

> There have been a couple of annoyances, though.
> 
> One is that MD reads from the disks sequentially, thus spinning up the
> disks one by one.
> The more disks you have, the longer you will have to wait for the
> entire array to come up :-/.
> Would have been beautiful if MD issues the requests in parallel.

Ack.

> Another is that you need to have your root partition outside of the array.

Which will be the case here...

> The reason for this is that some fancy feature in your favorite distro
> with guarantee periodically writes something to the disk, which will
> make the array spin up constantly.

Yup, I see that...

> Incidentally, this also makes using Linux as a desktop system a PITA,
> since the disks are noisy as hell if you leave it on.
> I'm currently using two old disks in RAID1 for the root filesystem,
> but I'm thinking that there's probably a better solution.
> Perhaps the root filesystem can be shifted to a ramdisk during
> startup.  Or you could boot from a custom made CD - that would also be
> extremely handy as a rescue disk.

Hm. Knoppix seems to be coming out in a new version real soon... ;)

Thanks for the feedback,

greets, tobi... :)

