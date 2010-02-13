From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Can this setup be saved?
Date: Fri, 12 Feb 2010 18:13:54 -0800
Message-ID: <4877c76c1002121813h410900by1c398c80e2aa0635@mail.gmail.com>
References: <c98f60c41002121756j5e8cd32fwdc2cd22ba553d241@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c98f60c41002121756j5e8cd32fwdc2cd22ba553d241@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitry Teytelman <dim@dimtel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 12, 2010 at 5:56 PM, Dmitry Teytelman <dim@dimtel.com> wrot=
e:
> Hello,
>
> I've made a mess of my raid setup and am desperately trying to save
> it. The setup is RAID-5 on 3 SATA disks. Problems started with one of
> the disks getting unrecoverable read errors. Unfortunately I was away
> on a trip and the machine was used by my family while this was going
> on :(
>
> Array consists of three devices: /dev/sda2, /dev/sdc2, and /dev/sdd2.
> When I got back from the trip I found the following:
>
> 1. Two disks were removed from the array, leaving only /dev/sda2;
> 2. When either of the two was added, the array would start;
> 3. One combination of two disks (/dev/sda2 + /dev/sdd2) aproduced a
> running /dev/md0 with a proper ext3 filesystem seen on the drive (eve=
n
> passing fsck);
>
> At this point I added /dev/sdc2 and the reconstruction started.
> However did not complete, since /dev/sdd2 has unrecoverable errors.
> Reading the list archives I figured I need another drive to ddrescue
> /dev/sdd2, then perform the reconstruction.
>
> However at some point during/after the reconstruction the situation
> has changed. Now both /dev/sdc2 and /dev/sdd2 are marked as spare
> drives (see mdadm -E output below) and I cannot start the array. I
> think /dev/sdd2 should be in sync with /dev/sda2, but how can I bring
> it back (it used to be device 2)?
>
> /dev/sda2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.01
> =A0 =A0 =A0 =A0 =A0 UUID : bd5c2dc0:f76e5f10:a98c4de7:f2020715
> =A0Creation Time : Fri Jun 17 11:47:44 2005
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 486375808 (463.84 GiB 498.05 GB)
> =A0 =A0 Array Size : 972751616 (927.69 GiB 996.10 GB)
> =A0 Raid Devices : 3
> =A0Total Devices : 1
> Preferred Minor : 0
>
> =A0 =A0Update Time : Fri Feb 12 14:07:35 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 1
> Working Devices : 1
> =A0Failed Devices : 2
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : a4cd0c48 - correct
> =A0 =A0 =A0 =A0 Events : 2125155
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 128K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed
>
> /dev/sdc2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.01
> =A0 =A0 =A0 =A0 =A0 UUID : bd5c2dc0:f76e5f10:a98c4de7:f2020715
> =A0Creation Time : Fri Jun 17 11:47:44 2005
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 486375808 (463.84 GiB 498.05 GB)
> =A0 =A0 Array Size : 972751616 (927.69 GiB 996.10 GB)
> =A0 Raid Devices : 3
> =A0Total Devices : 1
> Preferred Minor : 0
>
> =A0 =A0Update Time : Fri Feb 12 10:30:00 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 1
> Working Devices : 1
> =A0Failed Devices : 2
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : a4ccd973 - correct
> =A0 =A0 =A0 =A0 Events : 2125153
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 128K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 -1 =A0 =A0 =
=A0spare =A0 /dev/sdc2
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed
>
> /dev/sdd2:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 0.90.01
> =A0 =A0 =A0 =A0 =A0 UUID : bd5c2dc0:f76e5f10:a98c4de7:f2020715
> =A0Creation Time : Fri Jun 17 11:47:44 2005
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 486375808 (463.84 GiB 498.05 GB)
> =A0 =A0 Array Size : 972751616 (927.69 GiB 996.10 GB)
> =A0 Raid Devices : 3
> =A0Total Devices : 2
> Preferred Minor : 0
>
> =A0 =A0Update Time : Fri Feb 12 10:36:05 2010
> =A0 =A0 =A0 =A0 =A0State : active
> =A0Active Devices : 1
> Working Devices : 2
> =A0Failed Devices : 2
> =A0Spare Devices : 1
> =A0 =A0 =A0 Checksum : a4ccdb48 - correct
> =A0 =A0 =A0 =A0 Events : 2125154
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 128K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0spare =A0 /dev/sdd2
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0faulty removed
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 50 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0spare =A0 /dev/sdd2
>
>
> --
> Dmitry Teytelman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

It sounds like you've reached the point where you've done something
silly and need to try to recover what you can.

READ THIS SITE CAREFULLY; perform READ ONLY recovery, and see if you
can find a permutation that can be mounted read only and READ with
valid data;

DO NOT REUSE your current disks; they have been kicked for a FAILURE
TO WRITE (if you're using a recent kernel), and should be considered
walking dead.  If you are able to read your data, copy it off to a
fresh array.

IF your new disks are large enough to hold a complete copy of your old
drives and your new copy, then dd_rescue the old drives that are a
valid combination to the end of the disks, make your array in the
beginning, then when you're done copying it take the new array offline
too, extend the partitions, grow the array in to the partitions (and
any underlying structures like LVM)

http://raid.wiki.kernel.org/index.php/RAID_Recovery

http://raid.wiki.kernel.org/index.php/Permute_array.pl

#!/usr/bin/perl -w

# If you forgot how you built an array and need to try various
# permutations then this is for you...

# based on Mark-Jason Dominus' mjd_permute: permute each word of input

use strict;
use Getopt::Long;

sub usage {
 return "syntax: permute_array --md <md_device> --mount <mountpoint>
[--opts <mdadm options>] [--for_real] <all devices>\n";
}

my $MD_DEVICE;
my $MOUNTPOINT;
my $MDADM_OPTS=3D"";
my $REAL;

################################################################
# This function is passed each permutation of component devices.
# This includes a 'missing' device.
# This is the place to hack command variations etc...
sub try_array {
  # @_ looks like: ("/dev/sda1", "missing", "/dev/sdb1")
  my @device_list =3D @_;
  my $num_devices =3D scalar @_;

  # This may need a --force... <gulp>
  my $create =3D "yes | mdadm --create $MD_DEVICE
--raid-devices=3D$num_devices --level=3D5 $MDADM_OPTS @device_list
2>/dev/null\n";
  # Don't forget to mount read-only
  my $mount =3D  "mount -oro $MD_DEVICE $MOUNTPOINT 2>/dev/null";
  my $umount =3D  "umount $MOUNTPOINT 2>/dev/null";
  # and stop the array...
  my $stop =3D "mdadm --stop $MD_DEVICE 2>/dev/null";

  # REAL =3D=3D --for_real option
  if ($REAL) {
    # we expect this to succeed
    system $create;
    if (my $err =3D $?>>8) {
      die "command : $create\n   exited with status $err\n\n";
    }
    # we expect this to fail and are happy if it succeeds
    system $mount;
    if (!(my $err =3D $?>>8)) {
      print "Success. possible command : \n  $create\n";
      system $umount;
    }
    # we expect this to succeed
    system $stop;
    if (my $err =3D $?>>8) {
      die "command : $stop\n   exited with status $err\n\n";
    }
  } else {
    # Just show the create/mount/stop commands
    # If you want more control you could use this to write a script
    print "$create\n$mount\n$stop\n";
  }
}


################################################################
# Execution starts here...
#
sub factorial($);

GetOptions ('md=3Ds'      =3D> \$MD_DEVICE,
	    "mount=3Ds"   =3D> \$MOUNTPOINT,
	    "opts=3Ds"    =3D> \$MDADM_OPTS,
	    "for_real"  =3D> \$REAL);

if (!defined($MD_DEVICE) or !defined($MOUNTPOINT)) {
  die &usage;
}

print "using device $MD_DEVICE and mounting on $MOUNTPOINT\n";

# we *always* assume a 'missing' device - not doing so will destroy
# the array...
my @devices =3D @ARGV;
# how many devices?
my $num_devices =3D scalar @devices;
if ($num_devices < 2) {
  die "$0 needs at least two component devices\n";
}
# how many base permutations...
my $num_permutations =3D factorial(scalar @devices);
# try all permutations, substituting 'missing' for each device in
# turn...
for (my $d=3D0; $d < $num_devices; $d++) {
  my $skip_device =3D $devices[$d];
  $devices[$d] =3D "missing";
  print "skipping $skip_device\n\n";
  for (my $i=3D0; $i < $num_permutations; $i++) {
    my @permutation =3D @devices[n2perm($i, $#devices)];
    try_array(@permutation);
  }
  $devices[$d] =3D $skip_device;
}

################################################################
# permutation code

# n2pat($N, $len) : produce the $N-th pattern of length $len
sub n2pat {
    my $i   =3D 1;
    my $N   =3D shift;
    my $len =3D shift;
    my @pat;
    while ($i <=3D $len + 1) {   # Should really be just while ($N) { .=
=2E.
        push @pat, $N % $i;
        $N =3D int($N/$i);
        $i++;
    }
    return @pat;
}

# pat2perm(@pat) : turn pattern returned by n2pat() into
# permutation of integers.  XXX: splice is already O(N)
sub pat2perm {
    my @pat    =3D @_;
    my @source =3D (0 .. $#pat);
    my @perm;
    push @perm, splice(@source, (pop @pat), 1) while @pat;
    return @perm;
}

# n2perm($N, $len) : generate the Nth permutation of $len objects
sub n2perm {
    pat2perm(n2pat(@_));
}

# Utility function: factorial with memoizing
BEGIN {
  my @fact =3D (1);
  sub factorial($) {
    my $n =3D shift;
    return $fact[$n] if defined $fact[$n];
    $fact[$n] =3D $n * factorial($n - 1);
  }
}
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
