From: "aboster" <aboster@at-sd.com>
Subject: Raid 10 reassembly issue
Date: Fri, 23 Jul 2004 14:07:03 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000201c470f9$03e51950$cd03a8c0@archnet2.atgsd.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Running vanilla Red Hat 9, I assembled a raid 10, a stripe whose two
components were themselves raid 1's, and did a silly thing.

The raid1 components were md8 and md9.  Since md7 was free, I stupidly
assigned that to be the raid0 concatenation of md8 and md9.

The system happily worked for quite sometime.  Now we've rebooted.  

It appears to me (of course, I could be wrong about this) that what has
happened is that when it got to md7 during the boot process where it's
assembling the raids, md7's components were not started yet, so it has
removed md7 from the configuration.

As far as I know, the components (md8 and 9) have not been touched.

I need to reassemble the raid0, preferably with a different device number
(md20, say), without destroying the filesystem that I think might still be
intact (if the stripe were gently reassembled).

Can anyone take a minute to help?

Thanks!
Alex

