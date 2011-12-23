From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by smart
Date: Fri, 23 Dec 2011 13:59:21 -0600
Message-ID: <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com>
References: <87hb0r2kvq.fsf@poker.hands.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hb0r2kvq.fsf@poker.hands.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philip Hands <phil@hands.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2011 at 12:39 PM, Philip Hands <phil@hands.com> wrote:
> Hi,
>
> This is a little vague I'm afraid, but I've saved the syslogs, so ple=
ase
> feel free to ask for details if they'd help track down what's happeni=
ng.
>
> I'm running a relatively busy server (it hosts the VM for
> ftp.uk.debian.org among other things) which has 6 disks, four of whic=
h
> are 2TB Western Digital Caviar Black drives.
>
> Each of the 2TB drives is split into a couple of small partitions at =
the
> front (250MB & 750MB) on which are built 4-way RAID1s containing /boo=
t
> and / respectively, with the rest of the drives split into 4 ~500GB
> chunks, which are then assembled into 5 3-way RAID1s.
>
> A while ago, one of the drives started showing an increasing number o=
f
> pending sectors, over the course of several weeks getting up to 360 o=
r
> so. =C2=A0Meanwhile another of the drives got up to about 90 pending =
sectors.
>
> I assumed that by forcing a check, it would read the drives, notice t=
hat
> sectors were unreadable, and write the data back from one of the clea=
n
> drives, but having run checks on all drives, the number of pending
> sectors went down by about five or so each time (or once about ten) a=
nd
> then crept up again.
>
> So, I went in to the co-lo to see if there was something like a lose
> cable causing the problem, say -- and just before I left I removed th=
e
> drive with fewer pending sectors, zeroed the superblocks to ensure th=
at
> it really would rewrite things, and then added it back in -- it dropp=
ed
> the pending sector count from ~90 to 10 quite quickly, at which point
> smart started declaring the dive as failed. =C2=A0I've now replaced t=
hat drive.
>
> The replacement drive was fitted a few days ago, and has now synced u=
p.
>
> While it was syncing, the drive with 360-ish pending sectors started
> throwing many read errors, but the pending sector count remained
> static -- this seems wrong to me. =C2=A0Surely the md code should not=
ice the
> read errors, and decide to rewrite the data from the remaining drive.
>
> While the read errors were happening, the system performance became d=
ire
> (with system load going up to about 15, as opposed to the normal 1-3,
> and the whole system regularly pausing -- I had previously assumed th=
at
> this might be due to busy networks or dropped packets, but when I was
> on-site I noticed that when a read error was occurring, that all othe=
r
> disk activity would halt, as would the responsiveness of the CLI).
>
> So, I failed the 360-pending-sector drive out of the RAID, and all
> returned to normal, performance-wise.
>
> Once the RAID synced (the one remaining disk, and the one that was
> supplied as a replacement), I added the apparently duff dusk back int=
o
> the array, having zeroed its superblock, and made sure that the first
> array to rebuild was the one containing at least some of the pending
> sectors -- it turns out that that partition contained all of the pend=
ing
> sectors, as they are now all gone.
>
> None of those sectors has resulted in a reallocated sector, so they w=
ere
> soft errors it seems -- so what I'm wondering is why none of the chec=
ks
> or repairs I've run over the preceding weeks managed to put a dent in
> the number of pending sectors.
>
> I'll admit the possibility that some cabling or controller issue may =
have
> been causing the duff sectors, as I've now moved it to a different SA=
TA
> port, but even so, is seems that it wasn't even trying to rewrite the
> data. =C2=A0It seems more likely that there really is some fault with=
 the
> disk (especially since a smart long test has just revealed another
> unreadable sector in about the same area of the disk).
>
> Perhaps you can suggest what I should look out for in the logs to
> determine if read failures are really rewriting the blocks, or if my
> suspicion that it's not happening is true.
>
> Here's a sampling of one day's log which seems to show what I'm on
> about:
>
> =C2=A0http://hands.com/~phil/tmp/sheikh.hands.com-mdadm-syslog-201112=
05
>
> if for instance, you search for '25314' you'll find loads of this sor=
t
> of thing:
>
> Dec =C2=A05 17:00:54 sheikh kernel: [1663261.867952] md/raid1:md4: re=
directing sector 253145096 to other mirror: sdd4
> Dec =C2=A05 17:00:54 sheikh kernel: [1663262.017791] md/raid1:md4: re=
directing sector 253145104 to other mirror: sdd4
> Dec =C2=A05 17:00:55 sheikh kernel: [1663262.451139] md/raid1:md4: re=
directing sector 253145112 to other mirror: sdd4
> Dec =C2=A05 17:00:56 sheikh kernel: [1663263.409472] md/raid1:md4: re=
directing sector 253145120 to other mirror: sdd4
> Dec =C2=A05 17:00:56 sheikh kernel: [1663263.734508] md/raid1:md4: re=
directing sector 253145128 to other mirror: sdd4
> Dec =C2=A05 17:00:56 sheikh kernel: [1663263.967813] md/raid1:md4: re=
directing sector 253145136 to other mirror: sdd4
> Dec =C2=A05 17:00:56 sheikh kernel: [1663264.034509] md/raid1:md4: re=
directing sector 253145144 to other mirror: sdd4
> Dec =C2=A05 17:00:56 sheikh kernel: [1663264.209565] md/raid1:md4: re=
directing sector 253145152 to other mirror: sdd4
> Dec =C2=A05 17:00:58 sheikh kernel: [1663265.609860] md/raid1:md4: re=
directing sector 253145160 to other mirror: sdd4
> Dec =C2=A05 17:00:58 sheikh kernel: [1663265.992975] md/raid1:md4: re=
directing sector 253145168 to other mirror: sdd4
>
> often preceded by something like:
>
> Dec =C2=A05 17:00:41 sheikh kernel: [1663248.685965] md/raid1:md4: re=
ad error corrected (8 sectors at 253147088 on sdg4)
>
> but to my eye, there don't seem to be enough of these corrections to =
go
> with the errors, and they didn't get rid of all the pending sectors t=
hat
> have since been wiped out as described above.
>
> Once the raid that's currently rebuilding has finished (in about an
> hour), I'll tell it to do a check to see if that notices/fixes the ne=
w
> pending block that's turned up.
>


No idea if raid1 was rewriting the sectors or not...but I know my
raid6 was and performance was really bad while it was happening so it
probably would not have help you much.  I was typically seeing 30sec
pauses each time md found a set of bad sectors and forced the
rewrite...this went on for several days until finally smart would
offiically fail one of the drives and I replaced it with another one.
 It appears about the same time smart failed the drive that MD also
did (write failed as the drive appears to have ran out of spare sector
to relocate things to).


I had 4 1.5tb seagate drives from 2009 (bought at different times in
2009) and 3 of those 4 started getting lots of bad sector all within a
2 month period and all 3 finally officially failed smart.and when the
sectors (one after another...lucky they failed out aover 2-3 weeks so
I had got the replacements in before I lost data-I was down to no
redundancy for several days in the middle) were failing and being
rewritten the performance was just ugly--so even if raid1 was
rewriting the drives it does not do anything for performance when the
drives are going bad...the only thing that solved my performance was
getting all of the failing devices to finally fail smart so they could
be RMAed and replaced at minimal cost..
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
