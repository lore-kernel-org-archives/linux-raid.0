From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.9.0 - A tool for managing Soft RAID under Linux
Date: Fri, 4 Feb 2005 12:11:39 +1100
Message-ID: <16898.52171.979070.715369@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.9.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/linux/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.9.0 adds:
    -   Fix rpm build problem (stray %)
    -   Minor manpage updates
    -   Change "dirty" status to "active" as it was confusing people.
    -   --assemble --auto recognises 'standard' name and insists on using
        the appropriate major/minor number for them.
    -   Remove underscore from partition names, so partitions of 
	"foo" are "foo1", "foo2" etc (unchanged) and partitions of
	"f00" are "f00p1", "f00p2" etc rather than "f00_p1"...
    -   Use "major", "minor", "makedev" macros instead of 
	"MAJOR", "MINOR", "MKDEV" so that large device numbers work
	on 2.6 (providing you have glibc 2.3.3 or later).
    -   Add some missing closes of open file descriptors.
    -   Reread /proc/partition for every array assembled when using
	it to find devices, rather than only once.
    -   Make "mdadm -Ss" stop stacked devices properly, by reversing the
	order in which arrays are stopped.
    -   Improve some error messages.
    -   Allow device name to appear before first option, so e.g.
	mdadm /dev/md0 -A /dev/sd[ab]
	works.
    -   Assume '-Q' if just a device is given, rather than being silent.

This is based on 1.8.0 and *not* on 1.8.1 which was meant to be a pre-release 
for the upcoming 2.0.0.  The next prerelease will have a more obvious name.

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  04 February 2005

