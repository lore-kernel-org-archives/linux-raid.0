From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 08:36:57 +0200
Message-ID: <9hlej2-gke.ln1@news.it.uc3m.es>
References: <1113853825.1483.34.camel@debian> <426414A5.3020706@dgreaves.com> <1113865936.1483.73.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tmp <skrald@amossen.dk> wrote:
> I've read "man mdadm" and "man mdadm.conf" but I certainly doesn't ha=
ve
> an overview of software RAID.

Then try using it instead/as well as reading about it, and you will
obtain a more cmprehensive understanding.

> OK. The HOWTO describes mostly a raidtools context, however. Is the
> following correct then?
> mdadm.conf may be considered as the replacement for raidtab. When mda=
dm

No. Mdadm (generally speaking) does NOT use a configuration file and
that is perhaps its major difference wrt to raidtools.  Tt's command
line.  You can see for yourself what the man page itself summarises as
the differences (the one about not using a configuration file is #2 of
3):

    mdadm is a program that can be used to create, manage, and monitor
    MD devices.  As such it provides a similar set of functionality to
    the raidtools packages.  The key differ=AD ences between mdadm and
    raidtools are:

       mdadm is a single program and not a collection of pro=AD grams.

       mdadm can perform (almost) all of its functions with=AD out havi=
ng
       a configuration file and does not use one by default.  Also mdad=
m
       helps with management of the configuration file.

       mdadm can provide information about your arrays (through Query,
       Detail, and Examine) that raidtools cannot.


> starts it consults this file and starts the raid arrays corresponding=
ly.

No. As far as I am aware, the config file contains such details of
existing raid arrays as may conveniently be discovered during a
physical scan, and as such cntains only redundant information that at
most may save the cost of a physical scan during such operations as may
require it.

=46eel free to correct me!

> This leads to the following:

Then I'll ignore it :-).

> Is it correct that I can use whole disks (/dev/hdb) only if I make a
> partitionable array and thus creates the partitions UPON the raid
> mechanism?

Incomprehensible, I am afraid.  You can use either partitions or whole
disks in a raid array.

> As far as I can see, partitionable arrays makes disk replacements eas=
ier

Oh - you mean that the partitions can be recognized at bootup by the
kernel.

> You say I can't boot from such a partitionable raid array. Is that
> correctly understood?

Partitionable? Or partitioned? I'm not sure what you mean.

You would be able to boot via lilo from a partitioned RAID1 array, sinc=
e
all lilo requires is a block map of here to read the kernel image from,
and either component of the RAID1 would do, and I'm sure that lilo has
been altered to allow the use of both/either components blockmap during
its startup routines.

I don't know if grub can boot from a RAID1 array but it strikes me as
likely since it would be able to ignore the raid1-ness and boot
successfully just as though it were a (pre-raid-aware) lilo.

> Can I "grow" a partitionable raid array if I replace the existing dis=
ks
> with larger ones later?=20

Partitionable? Or partitioned? If you grew the array you would be
extending it beyond the last partition. The partition table itself is n
sector zero, so it is not affected. You would presumably next change
the partitions to take advatage of the increased size available.

> Would you prefer manual partitioned disks, even though disk replaceme=
nts
> are a bit more difficult?

I don't understand.

> I guess that mdadm automatically writes persistent superblocks to all
> disks?

By default, yes?

> I meant, the /dev/mdX has to be formatted, not the individual
> partitions. Still right?

I'm not sure what you mean. You mean "/dev/mdXy" by "individual
partitions"?

> So I could actually just pull out the disk, insert a new one and do a
> "mdadm -a /dev/mdX /dev/sdY"?

You might want to check that the old has been removed as well as faulte=
d
first. I would imagine it is "only" faulted. But it doesn't matter.

> The RAID system won't detect the newly inserted disk itself?

It obeys commands. You can program the hotplug system to add it in
autmatically.

> Are there some HOWTO out there, that is up-to-date and is based on RA=
ID
> usage with mdadm and kernel 2.6 instead of raidtools and kernel 2.2/2=
=2E4?

What there is seems fine to me if you can use the mdadm equivalents
instead of raidhotadd and raidsetfaulty and raidhotremve and mkraid.
The config file is not needed.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
