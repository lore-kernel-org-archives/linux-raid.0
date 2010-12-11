From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Degraded Array
Date: Fri, 10 Dec 2010 22:29:39 -0600
Message-ID: <CA.F2.19545.73EF20D4@cdptpa-omtalb.mail.rr.com>
References: <20101204174457.4249ba23@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101204174457.4249ba23@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>, "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	Well, that was painful, and more than a little odd.  As I reported
before, the system halted dead during the re-shape from 13 disks to 14 on
the RAID6 array of the main server.  The array reassembled after reboot, but
with only 12 drives.  I'm pretty sure one drive was missing because it (the
14th) wasn't in mdadm.conf, because of course I had not put it there, yet.
I'm not exactly sure why the 12th wasn't assembled in the array.  Any way,
during the continued re-shape, it halted again.  I brought it back up again,
and it eventually completed the re-shape, but with hundreds of thousands of
reported inconsistencies. I re-added the two faulted drives one at a time
and the recovery finished both times without apparent error.  When it was
done, I started looking at the file system, and it was a mess.  At one
point, XFS crashed altogether.  I ran XFS_Repair, and it found numerous
problems at the file system level.  Several files were lost.  I ran a cmp
between every file on the backup and on the RAID array I had just re-shaped,
and nearly every large file was corrupted.  Most small files were intact,
but a few of them were also toast.  The large files were not totally
unreadable, however.  In fact most of the videos were mostly intact, but
with frequent video breakups, stutters, and drop-outs encountered on every
file I checked that had failed the compare.  I then ran an rsync against the
corrupted file system with the --checksum option, but it did not copy most
of the files back from the backup, although it did copy quite a few.  Weird.
Checking a few of the known bad files with md5sum, every pair had different
CRCs.  I also checked a few apparently good files, and every pair of those
had matching CRCs.  I ran another cmp, piping the list of failures to a log
file, and then used the list to copy the remaining failed files back to the
main array.  Finally, I did one last cmp between the two, and every file
passed except those which were expected not to.

I have no idea what could have caused this, but given the symptoms it seems
likely the stripes on one of the drives were accidentally put in the wrong
place while the re-shape took place, or something like that.  On the up
side, the arrays have never performed better.  I'm very pleased.  Running
two TCP transfers at once over a 1000M Ethernet link, the transfers topped
out at over 928 Mbps.  Single TCP transfers managed better than 800Mbps.
Some intra-machine processes topped out at nearly 2200 Mbps.  There is no
sign at all of any corruption post re-shape.

