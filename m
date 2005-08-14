From: Stephen Walton <stephen.walton@csun.edu>
Subject: convert legacy array in place?
Date: Sun, 14 Aug 2005 14:40:12 -0700
Message-ID: <42FFBA3C.1010102@csun.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

It seems like this should be a FAQ but careful google and mailing list 
archive searches didn't seem to turn up anything.

I have two machines with legacy RAID-0 arrays created with raidtools.  I 
have updated one to Fedora Core 4 and now use mdadm.  Am I correct in 
thinking I have to use "mdadm --build" every boot to access the array?  
My mdadm.conf contains

DEVICES /dev/hda1 /dev/hdb1 /dev/hdc1
ARRAY /dev/md0 level=raid0 num-devices=3 
devices=/dev/hda1,/dev/hdb1,/dev/hdc1

but the array doesn't seem to come up by itself on boot.

On the same lines, can this array be converted to a new style array just 
by writing new superblocks, or do I have to do the 
backup-reformat-restore thing?

TIA.

