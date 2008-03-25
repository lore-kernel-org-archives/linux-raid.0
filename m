From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: component growing in raid5
Date: Tue, 25 Mar 2008 13:06:43 +0000
Message-ID: <18408.63715.481333.26215@tree.ty.sabi.co.uk>
References: <47E5FFB8.5030903@bteam.hu>
	<47E753C4.7030903@rabbit.us>
	<47E7C609.9000501@bteam.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E7C609.9000501@bteam.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Mon, 24 Mar 2008 16:17:29 +0100, Nagy Zoltan
>>> <kirk@bteam.hu> said:

> [ ... ] because the system is already up and running, i
> don't wan't to recreate the array [ ... ]

It looks like that you feel lucky :-).

>> As a side note I am also curious why do you go the raid55 path
>> (I am not very impressed however :)

> okay - i've run thru the whole scenario a few times - and always
> come get back to raid55, what would you do in myplace? :)

Well, it all depends what the array is for. However from some of
the previous messages it looks like it is pretty big, probably
with several dozen drives in it across more than a dozen hosts.

But it is not clear what it is being used for, except that IIRC it
is mostly for reading. Things like access patterns (multithreaded
or single client?) file size profile, availability required, etc.,
matter too.

Anyhow as to very broadly applicable if not optimal guidelines, I
would first apply Peter's (me :->) Law of RAID Level Choice:

  * If you don't know what you are doing, use RAID10.
  * If you know what you are doing, you are already using RAID10
    (except in a very few special cases).

To this I would add some general principles based on calls of
judgement on my part, but that several people seem to judge
differently (good luck to them!):

  * Single volume filesystems larger than 1-2TB require something
    like JFS or XFS (or Reiser4 or 'ext4' for the brave). Larger
    than 5-10TB is not entirely feasible with any filesystem
    currently known (just think 'fsck' times) even if the ZFS
    people glibly say otherwise (no 'fsck' ever!).

  * Single RAID volumes up to say 10-20TB are currently feasible,
    say as 24x(1+1)x1TB (for example with Thumpers). Beyond that
    I would not even try, and even that is a bit crazy. I don't
    think that one should put more than 10-15 drives at most in
    a single RAID volume, even a RAID10 ones.

  * Large storage pools can only be reasonably built by using
    multiple volumes across networks and on top of those some
    network/cluster file system, and it matters a bit whether
    single filesystem image is essential or not.

So my suggestions are:

  * For larger filesystems I would use multiple Thumpers (or
    equivalent) divided in multiple 2TB volumes with a network
    filesystem like OpenAFS for home directories or a parallel
    network filesystem like Lustre for data directories.

  * Multiple 2-4TB RAID10 volumes each with a JFS/XFS filesystem
    exported via NFSv4 might be acceptable if single filesystem
    image semantics are not required.

  * Consider the case for doing RAID10 over the network, by having
    for example two Thumpers with 48 drives and creating 48 RAID1
    pairs across the network using DBRD, and then creating 2-4TB
    RAID0 volumes with a half a dozen of those pairs each.

  * RAID5 (but not RAID6 or other mad arrangements) may be used if
    almost all accesses are reads, the data carries end-to-end
    checksums, and there are backups-of-record for restoring the
    data quickly, and then each array is not larger than say 4+1.
    In other words if RAID5 is used as a mostly RO frontend, for
    example to a large slow tape archive (thanks to R. Petkus for
    persuading me that there is this exception).

A couple of relevant papers for inspiration on best practices by
those that have to deal with this stuff:

  https://indico.desy.de/contributionDisplay.py?contribId=26&sessionId=40&confId=257
  http://indico.fnal.gov/contributionDisplay.py?contribId=43&amp;sessionId=30&amp;confId=805

> i choosed this way because:

>     * hardware raid controllers are expensive - because of
>       this i prefer rather having a cluster of machines
>       (average cost per MB shows that this is the 'cheapest'
>       solution) this solution's impact on avg cost is about
>       20-25% compared to a single stand-alone disk - 40-50% if
>       i count only usable storage

That's strange. Especially as iSCSI host adapters are not exactly
cheaper than SAS/SATA ones.

>     * as far as i know other raid configurations take a bigger
>       piece  from the cake
>         - raid10, raid01 both halves the usable space, simply
>           creating a raid0 array at the top level could suffer
>           complete destruction if a node fails (in some rare
>           cases the power-supply can take everything along with
>           it)

Check out http://WWW.BAARF.com/ for the "but RAID10 is not cost
effective" argument :-).

>         - raid05 could be reasonable choice providing n*(m-1)
>           space: but in case of failure a single disk would
>           trigger a full scale rebuild

Try to imagine what happens when 2 disks fail, either in two
different leaves or in the same leaf. Oops.

>     * raid55 - considering an array of n*m disks, gives
>       (n-1)*(m-1) usable space with the ability to detect
>       failing disks and repair them, while the cluster is still
>       online - i can even grow it without taking it offline! ;)

Assuming that there are no downsides :-) this makes perfect sense.

>       and at the leafs the processing power required for the
>       raid is already there...  why not use it? ;)

Which processing power required? RAID on current CPUs is almost
trivial, and with multilane PCIe and multibank fast DDR2 even
bandwidth is not a big deal.

>     * this is because with iscsi i can detach the node, and when
>       i reattach the node it's size is redetected

Sure, and much good it does you to have nodes of different sizes
in a RAID5 :-). Anyhow SAS/SATA is usually plug and play too.

[ ... ]

>     * an alternate solution could be: drop the top level raid5
>       away, and replace it with unionfs - by creating individual
>       filesystems, there is an intresting thing about raiding
>       filesystems(raif)

This would be a bit better, see above. Though I wonder why one
would need 'unionfs', as one could mount all lower level volumes'
filesystems into subdirectories.  That may not be acceptable, but
'unionfs' would not allow things like cross-filesystem hard links
for example, so not a big deal.

[ ... ]

>     * this cluster could scale up at any time by assimilating
>       new nodes ;)

Assuming that there are now downsides to that, fine ;-).
