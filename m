From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.2.0 - A tool for managing Soft RAID under Linux
Date: Thu, 13 Mar 2003 09:27:33 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15983.46165.380845.237040@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.2.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.2.0 is a bug-fix release over 1.1.0.

    -   Fix bug where --daemonise required an argument.
    -   In --assemble --verbose, print appropriate message if device is
        not in devices= list
    -   Updated mdadm.conf.5 to reflect fact that device= takes wildcards
    -   Typos:  componenet -> component
    -   Reduce size of "--help" message put excess into "--help-options"
    -   Fix bug introduced when MD_SB_DISKS dependancy removed, and which
        caused spares not be assembled properly.
    -   Print appropriate message if --monitor --scan decides not to
	monitor anything.  


Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  13/03/2003
