From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 and missing superblocks
Date: Sun, 9 Jan 2005 21:13:23 -0500
Message-ID: <200501100213.j0A2DV919152@www.watkins-home.com>
References: <1105321207.24159.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1105321207.24159.6.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: 'Aaron' <aaront@cmu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you re-create the array with the same parameters as when it was built
last, the data should still be there.  But if you get 1 factor wrong, say
good bye to your data.

The reason this works is simple...
On create, md does not write to the data blocks, just reads them to generate
the parity blocks, which do get written.  If the parity blocks get written
to the same place as before, no problem.  But if the parity is written to
different blocks, some data will be over written.  In your case, 1/2 of the
data could be lost.

Well, I just had an idea.  If you re-create your array but list 1 disk as
missing, it can't re-build or re-sync.  This will allow you to verify the
data.  If the data is bad/wrong, try again with different parameters.  Once
you are sure the data is good, add the last disk, then re-build will start.

Verify you data in a read only mode.  If possible.

More info may help.
Run this command on each disk:
mdadm -D /dev/<device>

I don't know if the above will work without a superblock.

Waiting for a second opinion can't hurt!  Just to be safe.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Aaron
Sent: Sunday, January 09, 2005 8:40 PM
To: linux-raid@vger.kernel.org
Subject: RAID5 and missing superblocks

I have a 3 disk RAID5 device that has had all 3 superblocks zeroed out
(don't ask, it's hard enough to even admit it ...).  The disks are
healthy and the data is there, but is there any way to ever assemble the
array again?  I have tried the simple approaches with mdadm --assemble
--force and raidstart with no luck.

Thanks,
Aaron


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

