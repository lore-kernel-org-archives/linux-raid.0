From: Michael Stumpf <mjstumpf@pobox.com>
Subject: bit-rot, crc errors, etc question
Date: Thu, 06 Oct 2005 11:27:16 -0500
Message-ID: <43455064.8020102@pobox.com>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quick question:

Been running a large ext3 filesystem on an LVM set with multiple linux 
/dev/mdX raid5 arrays underneath.  Recently, upon trying to do full 
identical rewrites of every bit (literally) of data, I'm starting to 
find cases where the server locks up/reboots, and the culprit seems to 
be tracked to a first failure of one of the ATA drives having a bad 
CRC.  Replacing the single bad drive fixes the issue.

My best guess is this:  the filesystem is built on the LVM, composed of 
extents.  The extents reside on physical volumes.  The physical volumes 
are developing uncorrectable errors through natural use/time/heat/secret 
alien plot.  These silent failures sit around until I try to access 
those pieces of those drives, at which point big catastrophic failures 
occur, incurring downtime, potential data loss, and expense.

How can I 1) prevent this,  2) detect this,  3) correct this without 
tossing the drive for a single small bad area?

Is the md driver set smart enough to correct around such physical media 
errors?  Are there ways via mdadm/other tools to actively scan for such 
bad areas (obviously in this case filesystem tools to do this are 
useless, right)?  Can I potentially continue using this "bad" drive by 
somehow applying a correction?

Regards-
Michael Stumpf








