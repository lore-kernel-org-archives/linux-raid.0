From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Odd raid1 rebuild performance
Date: 24 Feb 2003 09:44:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1046097898.30229.8.camel@wmery000.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been doing some testing lately with raid1 rebuilds.

I'm using an dual PentiumIV Xeon CPU system, with an adaptec UltraSCSI
320 controller and dual 10K RPM SCSI disks.

I simulate a failure of one of the disks, and then simulate the
replacement of the "failed" disk.

The first time I do this, I get good rebuild performance of
approximately 40MB/s.

If I then go ahead and repeat exactly the same test once the rebuild has
completed, I get relatively poor performance of approximately 6.3MB/s. 

If I reboot the system, the rebuild rate goes back up to 40MB/s for the
first rebuild, but the second is poor as above.

There is no change in the system load between the tests. The system load
is virtually non-existent during my testing.

I'm using 2.4.19 kernel, with the 1.3.0 aic79xx adaptec SCSI driver, and
the XFS 1.2 release. I've applied a patch I received from Neil Brown to
reduce the frequency of a kernel oops I was seeing.

Any suggestions as to how I can help to debug this?

Thanks!

Sean.

-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

