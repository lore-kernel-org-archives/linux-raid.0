From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.12.0 - A tool for managing Soft RAID under Linux
Date: Tue, 14 Jun 2005 13:55:01 +1000
Message-ID: <17070.21781.242958.788715@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


[[NOTE: a number of the improvements in this release were extracted
  from the current debian package.  If any package maintainers for
  other distros are sitting on patches that might be more widely
  usefully, I'd love to hear about them...
]]


I am pleased to announce the availability of 
   mdadm version 1.12.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.12.0 adds:
  Several of these are backported from the Debian package
    -   Don't use 'lstat' to check for blockdevices, use stat.
    -   Get size calculation right when in Create when BLKGESIZE64 not available
    -   Document --size=max option for --grow
    -   Document SparesMissing event and DeviceDisappeared/WrongLevel
    -   --stop --scan repeatly cycles until no more progress can be made
	so that stack devices are stopped properly
    -   Minor type rationalisation for ident->uuid - now always 'int[]'
    -   Fix type in online help for --grow (was -F, now -G)
    -   Allow --auto command line option to set default auto=
	value when running "--assemble --scan".  Previously
	--auto was ignored if --scan was given
    -   Fix a few type casts
    -   Fix parsing of /dev/md/N in is_standard
    -   Fix rounding errors in human_size()
    -   Fix silly example in mdadm.conf-examples
    -   When finding a /dev name for a device, prefer shorter names
    -   Suppress listing of devices= in --brief output of -D or -E,
	unless -v is given (-vv gives the old behaviour with -Dsv).
	This is because the device list can change and so is not a
	stable aspect of the array
    -   Allow --force with --grow so '-Gfn1' works (on raid1)
    -   Make --examine --brief report spares= properly.
    -   When device files are made with "--assemble --auto",
	add them to the list of known device name, so that 
	assembling stacked devices has a better chance of working.
    -   Replace sprintf calls with snprintf (to quiet diet-libc)
    -   Add man page for mdassemble
    -   Fix compilation with tinyc
    -   Lot of minor manpage updates

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  14 June 2005

