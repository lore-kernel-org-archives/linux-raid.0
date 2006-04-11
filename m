From: dean gaudet <dean@arctic.org>
Subject: forcing a read on a known bad block
Date: Tue, 11 Apr 2006 14:57:36 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0604092000020.29514@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hey Neil...

i've been wanting to test out the reconstruct-on-read-error code... and 
i've had two chances to do so, but haven't be able to force md to read the 
appropriate block to trigger the code.

i had two disks with SMART Current_Pending_Sector > 0 (which indicates 
pending read error) and i did SMART long self-tests to find out where the 
bad block was (it should show the LBA in the SMART error log)...

one disk was in a raid1 -- and so it was kind of random which of the two 
disks would be read from if i tried to seek to that LBA and read... in 
theory with O_DIRECT i should have been able to randomly get the right 
disk, but that seems a bit clunky.  unfortunately i didn't think of the 
O_DIRECT trick until after i'd given up and decided to just resync the 
whole disk proactively.

the other disk was in a raid5 ... 5 disk raid5, so 20% chance of the bad 
block being in parity.  i copied the kernel code to be sure, and sure 
enough the bad block was in parity... just bad luck :)  so i can't force a 
read there any way that i know of...

anyhow this made me wonder if there's some other existing trick to force 
such reads/reconstructions to occur... or perhaps this might be a useful 
future feature.

on the raid5 disk i actually tried reading the LBA directly from the 
component device and it didn't trigger the read error, so now i'm a bit 
skeptical of the SMART log and/or my computation of the seek offset in the 
partition... but the above question is still interesting.

-dean
