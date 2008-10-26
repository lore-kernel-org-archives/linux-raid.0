From: Neil Brown <neilb@suse.de>
Subject: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 09:56:12 +1100
Message-ID: <18692.62860.863118.727187@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


Greeting.
 This is a Request For Comments....

 Device naming in mdadm is a bit of a mess.
 We have partitioned devices (mdp) and non-partitioned (md)
 We have names in /dev/md/ (/dev/md/d0) and directly in /dev
    (/dev/md_d0).
 We have support for user-friendly names (/dev/md/home) and for
    "kernel-internal" names (/dev/md0).

 All this can produce extra confusion when udev is brought into the
 picture.  And it can leave lots of litter lying around in /dev if we
 aren't careful (which we aren't).

 I hope to release mdadm-3.0 this year, and maybe that gives me a
 chance to get it "right".  I don't want to break backwards
 compatibility in a big way, but I think I am happy to introduce
 little changes if it means a more consistent model.

 In 2.6.28, partitioned devices (mdp) wont be needed any more as md
 will make use of the "extended partition" functionality recently
 added.  All md devices can be partitioned.  The device number for the
 partitions will be very different to that of the whole device, but
 udev should hide all of that.  So we don't have to worry too much
 about mdp devices.

 So I think the following is how I want things to work.  I am very
 open to comments and suggestions.  Particularly I want to know what
 (if anything) this will break.

 1/ The only device nodes created will be /dev/mdX and /dev/md_dX
    along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
    These will be created by mdadm in accordance with the "--auto"
    flag unless something in mdadm.conf says to leave it to udev.
    In that case, mdadm will create a temporary node
    (/dev/.mdadm.whatever) and remove it once udev has created the
    real thing.

 2/ There will be various symlinks to these devices.
    a/ if "symlinks=yes" is given in mdadm.conf, symlinks from
         /dev/md/X or /dev/md/dX will be created.
    b/ if udev is configured like on Debian,
              /dev/disk/by-id/md-name-XXXX
	and   /dev/disk/by-id/md-uuid-UUUU
       will be created (by udev).
    c/ If there is a 'name' associated with the array then
        /dev/md/name will be created as a link.
    d/ if an explicit device name of /dev/name was given,
        either on a -A, -B, -C, command or in mdadm.conf,
	then the 'name' must match the name of the array,
	and /dev/name will be used as well as /dev/md/name.

 3/ For a 'NAME' to be used, with as md-name-NAME or /dev/md/NAME,
    we need a high degree of confidence that the array was intended
    for "this" host, or otherwise is not going to conflict with
    an array that is meant for "this" host.
    We get this confidence in a number of ways:
    a/ If the name is listed in /etc/mdadm.conf 
       e.g.  ARRAY /dev/md/home UUID=XXXX.....
    b/ If the name was given on the command line
    b/ If the name is stored in the metadata of an array which is
       explicitly identifed in mdadm.conf or by the command line.
    c/ If the name is of the form  "host:name" and "host" matches
       this host.  We then use just "name".
    d/ If the name is of the form "host:name" and "host" does not
       match this host, we can still assume that "host:name" is
       unique and use that.
    e/ For 0.90 metadata, if the uuid has the host name encoded in it
       then it was intended for 'this' host.

    Thus unsafe names are names extracted from the metadata of arrays
    which are auto-detected, where there is no hint in the metadata
    that the array is built for 'this' host.

    If the NAME is not known to be safe, we can still assemble the
    array, but we use a "random" high minor number, and allow it
    to be found primarily by the by-id/md-uuid-UUUUU... link or some
    other link created based on array content: e.g. disk/by-label/
    Also the array will be assembled "auto-readonly" so no resync etc
    will happen until the array is actually used.

    mdadm-3.0 will be able to support "containers" such as a set of
    devices with DDF metadata.  These can then contain a number of
    different arrays.  If the 'container' is known to be local to
    'this' host, then we assume that all contained arrays are too.

    I'm contemplating creating a link based on the metadata type with
    a sequential number. e.g. /dev/md/ddf1 or /dev/md/imsm2.
    I'm not sure if there should be in /dev/md/ or directly in /dev/.
    I'm also not sure if I should leave the creation to udev, and
    whether I should use a small sequential number, or just whatever
    number was allocated as the minor number of the device.

 4/ When we stop an array, mdadm will remove anything from /dev that
    it probably created.
    In particular, it will remove the device node as described in 1,
    any partitions, and any symlinks in /dev or /dev/md which point to
    any of those.  I need to be certain that this won't confuse udev.

 5/ I want to enable assembly without having to give
    an explicit device name, thus requiring mdadm to automatically
    assign one just as it would for auto-assembly.
    In particular, the "ARRAY" line in mdadm.conf will no longer
    require an array name.  That would mean that "-Es" wouldn't need
    to produce an array name (which is not always easy).
    So:
        mdadm -Es > /tmp/mdadm.conf
	mdadm -Asc/tmp/mdadm.conf
    would leave the choice of device name to the "-A" stage which is
    the only time that unique non-predictable names can be chosen.

 6/ I'm thinking that if the array name given to --create or
    --assemble looks as though it identifies a metadata type, by
    having the name of a metadata type followed by some digits,
    e.g. /dev/ddf0 or /dev/md/imsm3
    then we insist that the array have that metadata type.
    That could mean that a future metadata type might conflict with
    a previously valid usage, which would be a bore.
    Maybe if there are trailing digits, then it *must* identify a
    metadata type, or be "mdNN".

Some issues that all of this needs to address:

 1/ People want auto-assembly.  I've always fought against it (we
    don't auto-mount all filesystems do we?).  But it is a loosing
    battle.  And on a modern desktop, when you plug in a new drive the
    filesystem is automatically mounted.  So my argument is falling
    apart.

 2/ Auto-assembly of new arrays must not conflict with auto-assembly
    of previously existing arrays, even if the devices comprising the
    new arrays are discovered earlier.  This is what the 'homehost'
    concept is for.  Your array will only get assembled with a
    predictable name if it is known to be attached to 'this' host.

 3/ Auto-assembly needs to handle incremental arrival of devices
    correctly.  There are no easy solutions to this, particularly when
    e.g. ext3 can write to the device even when mounted read-only (for
    journal replay).
    I think the best that I can do for now is assemble things
    'read-auto' to delay any writes a long as possible in the hope
    that all available devices will be connected by then.
    Adding in-memory bitmaps for all degraded array to accelerate
    rebuild would help but won't be in 2.6.28.

 4/ auto-assembly needs to do the right thing on a SAN where multiple
    hosts can each see multiple arrays.  Clearly only one host should
    write to any one array at one time (until I get some
    cluster-awareness going, which I had hoped to work on this year,
    but it doesn't look like I will).
    In this case, I don't think read-auto is enough.  We either need
    to not assemble arrays when aren't known to belong to us, or we
    need to assemble them read-only and require and explicit
    read-write setting.

    So we need some way to know which devices could be visible to
    other hosts.
    I could have a global flag in mdadm.conf "Options SAN"
    I could have a SAN-DEVICES to match "DEVICES", but as just about
    everything is "/dev/sd*" these days, I don't know if that would
    work.

    Any suggestions concerning this would be welcome.

I'm also wondering if I should include a udev 'rules' file for md in
the mdadm distribution.  Obviously it would be no more than a
recommendation, but it might give me a voice in guiding how udev
interacted with mdadm.

Any thoughts of any of this would be most welcome.

Thanks,
NeilBrown


