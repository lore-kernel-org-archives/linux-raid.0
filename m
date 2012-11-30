From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Raid 0+1
Date: Fri, 30 Nov 2012 17:25:08 +0100
Message-ID: <50B8DDE4.5010900@profitbricks.com>
References: <CAAo+KF=-XStwczZvxPh7jgLZzwEAD71XWWg0h5HBXekBO8-5vQ@mail.gmail.com> <50B8C26C.7000807@profitbricks.com> <20121130152954.GR29064@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121130152954.GR29064@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30.11.2012 16:29, Lars Marowsky-Bree wrote:
> On 2012-11-30T15:27:56, Sebastian Riemer <sebastian.riemer@profitbric=
ks.com> wrote:
>=20
>> Yes, it is possible but it only makes sense if you want to mirror to
>> another server as most people know that the alternative DRBD is too =
slow
>> for serious storage requirements.
>>
>> Create the RAID-0 first, then take your RAID-0 device and e.g. an iS=
CSI
>> device from another storage server with the same setup and create a
>> RAID-1 over them. Then, you've got your stacked MD layers.
>>
>> With the flag write-mostly you can even tell the read balancing that=
 the
>> remote device is slower than the local one.
>=20
> That is somewhat orthogonal to the original discussion, but in which
> benchmarks is this approach faster than DRBD - aren't the bottlenecks
> still the spindle and the network IO?
>=20

Hi Lars,

just "blktrace" DRBD while doing a file copy with at least 512 KiB
read-ahead. Power off the secondary and "blktrace" again.

Here is what you'll see:
DRBD uses 128 KiB hashing functions. You can never get bigger IOs than
that - bad for big sequential stuff.

In the second test you'll see that DRBD has a dynamic IO request size
detection. It always starts with 4 KiB limits. If you loose connection
to the other host even your local IO is limited to 4 KiB. Sorry, but
this is crap.

There are lots of other performance related bugs in DRBD. If you run it
in a virtual data center, then you'll see 4 KiB IOs while syncing
because they use the blk limits as signed instead of unsigned and KVM
initializes them as "-1U". They've fixed that one in 8.3.14 and 8.4.2.

=46urthermore, there are lots of performance issues that you see clearl=
y
if you use a fast transport like QDR InfiniBand. We had ridiculous
performance with that. DRBD introduces lots of latency.

With SRP transport things are much better. Put MD RAID-1 on top and thi=
s
is nice! If you've got both rdevs as remote storage you can even have
symmetric (both rdevs the same) latency with MD RAID-1.

The write-intent bitmap of MD is really sophisticated!

Cheers,
Sebastian


--=20
Sebastian Riemer
Linux Kernel Developer - Storage

We are looking for (SENIOR) LINUX KERNEL DEVELOPERS!

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer@profitbricks.com

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
