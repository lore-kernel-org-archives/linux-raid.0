From: =?iso-8859-2?Q?Karel_Kulhav=FD?= <clock@twibright.com>
Subject: mkraid with 2.6.0
Date: Fri, 9 Jan 2004 14:55:47 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040109145547.B19523@beton.cybernet.src>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

bash-2.05b# mkraid /dev/md0
/dev/md1: array is active -- run raidstop first.
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as well
 for potential clues.)

It seems like mkraid from raidtools-1.00.3 doesn't work with 2.6.0 kernel.
I want it to make /dev/md0 and it tell me /dev/md1 is active - /dev/md1
is active, but it is not a reason to refuse to work.

Cl<
