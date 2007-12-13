From: greg@enjellic.com
Subject: Auto assembly errors with mdadm and 64K aligned partitions.
Date: Thu, 13 Dec 2007 11:15:44 -0600
Message-ID: <200712131715.lBDHFitB005137@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning to Neil and everyone on the list, hope your respective
days are going well.

Quick overview.  We've isolated what appears to be a failure mode with
mdadm assembling RAID1 (and presumably other level) volumes which
kernel based RAID autostart is able to do correctly.

We picked up on the problem with OES based systems with SAN attached
volumes.  I am able to reproduce the problem under 2.6.23.9 UML with
version 2.6.4 of mdadm.

The problem occurs when partitions are aligned on a 64K boundary.  Any
64K boundary seems to work, ie 128, 256 and 512 sector offsets.

Block devices look like the following:

---------------------------------------------------------------------------
cat /proc/partions:

major minor  #blocks  name

  98     0     262144 ubda
  98    16      10240 ubdb
  98    17      10176 ubdb1
  98    32      10240 ubdc
  98    33      10176 ubdc1
---------------------------------------------------------------------------


A RAID1 device was created and started consisting of the /dev/ubdb1
and /dev/ubdc1 partitions.  An /etc/mdadm.conf file was generated
which contains the following:

---------------------------------------------------------------------------
DEVICE partitions
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=e604c49e:d3a948fd:13d9bc11:dbc82862
---------------------------------------------------------------------------


The RAID1 device was shutdown.  The following assembly command yielded:

---------------------------------------------------------------------------
mdadm -As

mdadm: WARNING /dev/ubdc1 and /dev/ubdc appear to have very similar superblocks.      If they are really different, please --zero the superblock on one
      If they are the same or overlap, please remove one from the
      DEVICE list in mdadm.conf.
---------------------------------------------------------------------------


Interestingly after each failed assembly one of the partitions is
de-registered from the kernel.  This results in the third assembly
attempt succeeding.  Things seem a bit confused at this point however.

The kernel considers the following block devices available:

---------------------------------------------------------------------------
cat /proc/partitions:

major minor  #blocks  name

  98     0     262144 ubda
  98    16      10240 ubdb
  98    32      10240 ubdc
   9     0      10112 md0
---------------------------------------------------------------------------

While the active RAID1 volume looks like the following:

---------------------------------------------------------------------------
cat /proc/mdstat:

Personalities : [raid1]
md0 : active raid1 ubdb[0] ubdc[1]
      10112 blocks [2/2] [UU]

unused devices: <none>
---------------------------------------------------------------------------


The RAID1 device was then shutdown.  The /dev/ubdb1 and /dev/ubdc1
partitions were set to 'Linux raid autodetect'.

The UML session was shutdown and a new UML kernel with RAID1 compiled
in with autodetect enabled was started.  The kernel discovered and
activated the RAID1 device:

---------------------------------------------------------------------------
cat /proc/mdstat:

Personalities : [raid1]
md0 : active raid1 ubdc1[1] ubdb1[0]
      10112 blocks [2/2] [UU]

unused devices: <none>
---------------------------------------------------------------------------

Block devices as follows:

---------------------------------------------------------------------------
cat /proc/partitions:

major minor  #blocks  name

  98     0     262144 ubda
  98    16      10240 ubdb
  98    17      10176 ubdb1
  98    32      10240 ubdc
  98    33      10176 ubdc1
   9     0      10112 md0
---------------------------------------------------------------------------


The problem occurs with the default 0.9 superblocks.  Volumes created
with 1.0 based superblocks start properly.

I can provide more information and testing if needed.  The problem
appears to be trivially reproducible however.

I will look forward to any thoughts or suggestions from the
collective.

Best wishes for a productive remainder of the week.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"The couple is registered at Herbergers, Target and Fleet Farm."
                                -- Wedding invitation
                                   West Central Minnesota
