From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: A few mdadm questions
Date: Mon, 15 Nov 2004 00:34:16 -0500
Message-ID: <200411150534.iAF5YLN18378@www.watkins-home.com>
References: <16791.60777.951575.384927@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16791.60777.951575.384927@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>, 'Robert Osiel' <bob@osiel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I guess I have been confused.  I did not realize this was a 5 disk RAID5
with 1 spare.  Six disks total.  Is this correct?

If the above is correct, then:
Based on Neil's email, I now see that /dev/hdi1 is and was the spare.
This is the device that was hot removed.
This device should have no data on it.  So it should not be included when
trying to recover.

Just to be safe, do you know the device names of the six devices in the
array?  If so, try to assemble, but don't include hdi1 or hdk1.  If Neil is
correct, your 2 failures were only 2 seconds apart.  Has your array been
down since Sat Sep 25 22:07:26 2004?  If so, I guess hdk1 can't be too out
of date!  So, use it if needed.

Neil said to use this command:
mdadm -A /dev/md0 --uuid=ec2e64a8:fffd3e41:ffee5518:2f3e858c --force
/dev/hd?1
I am worried that it may attempt to use hdi1, which is the spare.
Also, I don't know that all of your devices match hd?1.  I have never seen
the complete list of devices.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Neil Brown
Sent: Sunday, November 14, 2004 6:43 PM
To: Robert Osiel
Cc: Guy; linux-raid@vger.kernel.org
Subject: Re: A few mdadm questions

On Sunday November 14, bob@osiel.org wrote:
> 
> I'll wait and see if Neil has any advice. *crosses fingers*
> 

Well, my reading of the information you sent (very complete, thanks),
is:

At
   Update Time Sat Sep 25 22:07:24 2004

when /dev/hdk1 last had a superblock update, the array have one failed
drive (not present) and one spare.
At this point it *should* have been rebuilding the spare to replace the
missing device, but I cannot tell if it actually was.

At
   Update Time Sat Sep 25 22:07:26 2004
(2 seconds later) when /dev/hdi1 was last written another drive had
failed, apparently [major=56, minor=1] which is /dev/hdi1 on my
system, but seems to be different for you.

If that drive, whichever it is, is really dead, then you have lost all
your data.  If, however, it was a transient error or even a
single-block-error then you can recover most of it with
  mdadm -A /dev/md0 --uuid=ec2e64a8:fffd3e41:ffee5518:2f3e858c --force
/dev/hd?1

This will choose the best 4 drives and assemble a degraded array with
them.  It will only update the superblocks and assemble the array - it
won't touch the data at all.

You can then try mounting the filesystem read-only and dumping the
data to backup.

When you add the 5th drive (hdi?) it should start rebuilding.  If it
gets a read error on one of the drives, the rebuild will fail, but the
data should still be safe.

I'm still very surprised that you managed to "raidhotremove" without
"raidsetfaulty" first... What kernel (exactly) are you running?

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

