From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.3.0 - A tools for managing Soft RAID under Linux
Date: Tue, 29 Jul 2003 11:27:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16165.52616.494056.280596@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.3.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.3.0 is a bug-fix and minor feature update release over 1.2.0.

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  29 Jul 2003

-------------------------------------------------------
Changes Prior to 1.3.0 release
    -   Make 'size' and unsigned long in Create to allow creation of
        larger arrays.
    -   Explicitly flag spare devices as 'spare' in --detail and --examine
        output.  Previously they simply had no flags lists.
    -   Make MailCmd (for monitor) configurable in Makefile, and default
        to "/usr/sbin/sendmail -t". Also split out the warning related
	flags into CWFLAGS for easier build configurability.
    -   Minor bugfix in Manage code.
    -   --monitor now notices and reports degraded arrays at startup using
        "DegradedArray" event, and also has a --oneshot option to only
	report DegradedArrays, and then exit.
    -   Small man-page clarification w.r.t. raid levels and raid4 in
        particular.
    -   Disallow creation of arrays with only one device as this is
        probably a mistake.  --force will override this check.
    -   Correct some misleading documentation in the "mdadm --create --help"
	message.
    -   Ignore chunksize if raid1 or multipath.
    -   Explicit statement in man page that raid-disks cannot be changed
        after array is created.
    -   Improve message when attempting to start an array with
        insufficient devices.  Instead of required the array to be full,
	we only require it has as many active devices as last time.
