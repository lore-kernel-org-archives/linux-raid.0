From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: ANNOUNCE: mdadm 1.5.0 - A tool for managing Soft RAID under Linux
Date: Thu, 22 Jan 2004 13:23:21 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16399.13337.814097.625065@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>
List-Id: linux-raid.ids



I am pleased to announce the availability of 
   mdadm version 1.5.0
It is available at
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
and
   http://www.{countrycode}.kernel.org/pub/utils/raid/mdadm/

as a source tar-ball and (at the first site) as an SRPM, and as an RPM for i386.

mdadm is a tool for creating, managing and monitoring
device arrays using the "md" driver in Linux, also
known as Software RAID arrays.

Release 1.5.0 adds:
  - new command "mdassemble" for use in initrd/initramfs.
  - raid6 support (for 2.6.2 and later kernels)
  - RebuildFinished event in monitor mode.
  - include rebuild status in --detail output.
  - fixes for assorted compilation problems

Development of mdadm is sponsored by CSE@UNSW: 
  The School of Computer Science and Engineering
at
  The University of New South Wales

NeilBrown  22 Jan 2004
