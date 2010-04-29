From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: More Hot Unplug/Plug work
Date: Thu, 29 Apr 2010 14:22:12 -0700
Message-ID: <r2ve9c3a7c21004291422q2144eaffsd16c8fe3c5ff8784@mail.gmail.com>
References: <4BD714A3.9020801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD714A3.9020801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Tue, Apr 27, 2010 at 9:45 AM, Doug Ledford <dledford@redhat.com> wro=
te:
> So I pulled down Neil's git repo and started working from his hotunpl=
ug
> branch, which was his version of my hotunplug patch. =A0I had to do a
> couple minor fixes to it to make it work. =A0I then simply continued =
on
> from there. =A0I have a branch in my git repo that tracks his hotunpl=
ug
> branch and is also called hotunplug. =A0That's where my current work =
is at.
>
> What I've done since then:
>
> 1) I've implemented a new config file line type: DOMAIN
> =A0 a) Each DOMAIN line must have at least one valid path=3D entry, b=
ut may
> =A0 =A0 =A0have more than one path=3D entry. =A0path=3D entries are f=
ile globs and
> =A0 =A0 =A0must match something in /dev/disk/by-path
> =A0 b) Each DOMAIN line must have one and only one action=3D entry. =A0=
Valid
> =A0 =A0 =A0action items are: ignore, incremental, spare, grow, partit=
ion.
> =A0 =A0 =A0In addition, a word me be prefixed with force- to indicate=
 that
> =A0 =A0 =A0we should skip certain safety checks and use the device ev=
en if it
> =A0 =A0 =A0isn't clean.

Just to clarify that we are on the same page with these actions:
* incremental is the default action that "does the right thing" if the
drive already has metadata.  I assume we need checks here to reject
disks with ambiguous (multiple valid metadata records)
* spare: implies incremental, but if it is a 'bare' device write a spar=
e record
* grow: implies incremental but if it is a 'bare' device write a spare
record, if there is a degraded array in the domain rebuild it
otherwise grow an(y?) array in the domain
* partition: if the device has a partition that matches the specified
table then add the partitions incrementally

A few comments:
1/ Does 'partition' need to be split to 'partition-spare' and
'partition-grow' to imply the action post partitioning?
2/ One of the safety checks for hot-inserting a spare is that it
occurs on a port that was recently unplugged.  Should that be a
default policy or do we need a different flavor spare action like
'spare-same-port'.

> =A0 c) Each DOMAIN line may have a metadata entry, and may have a
> =A0 =A0 =A0spare-group entry.

What is the purpose of the spare group?  I thought we were assuming
that all DOMAIN members were automatically in the same spare group.
Is this to augment the policy to allow spares to float between
DOMAINs?  Something like the following where the different domains
allow spares to cross boundaries?
DOMAIN path=3DA spare-group=3DB action=3Dgrow
DOMAIN path=3DB spare-group=3DA action=3Dspare

> =A0 d) For the partition action, a DOMAIN line must have a program=3D=
 and
> =A0 =A0 =A0a table=3D entry. =A0Currently, the program=3D entry must =
be an item
> =A0 =A0 =A0out of a list of known partition programs (I'm working on =
getting
> =A0 =A0 =A0sfdisk up and running, but for arches other than x86, othe=
r
> =A0 =A0 =A0methods would be needed, and I'm planning on adding a meth=
od
> =A0 =A0 =A0that allows us to call out to a user supplied script/progr=
am
> =A0 =A0 =A0instead of a known internal method). =A0The table=3D entry=
 points to
> =A0 =A0 =A0a file that contains a method specific table indicating th=
e
> =A0 =A0 =A0necessary partition layout. =A0As mentioned in previous ma=
ils, we
> =A0 =A0 =A0only support identical partition tables at this point. =A0=
That
> =A0 =A0 =A0may never change, who knows.
>
> 2) Created a new udev rules file that gets installed as
> 05-md-early.rules. =A0This rule file, combined with our existing rule=
s
> file, is a key element to how this domain support works. =A0In partic=
ular,
> udev rules allow us to separate out devices that already have some so=
rt
> of raid superblock from devices that don't. =A0We then add a new flag=
 to
> our incremental mode to indicate that a device currently does not bel=
ong
> to us, and we perform a series of checks to see if it should, and if =
so,
> we "grab" it (I would have preferred a better name, but the short
> options for better names were already taken). =A0When called with the
> "grab" flag, we follow a different code path where we check the domai=
n
> of the device against our DOMAIN entries and if we have a match, we
> perform the specified action. =A0There will need to be some additiona=
l
> work to catch certain corner cases, such as the case where we have
> force-partition and we insert a disk that currently has a raid
> superblock on the bare drive. =A0We will currently miss that situatio=
n and
> not grab the device. =A0So, this is a work in progress and not yet co=
mplete.
>

I notice this rules file grabs all events.  Did you see, or disagree,
with the suggestion to have a mdadm --activate-domains command to
generate udev rules for the paths we care about?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
