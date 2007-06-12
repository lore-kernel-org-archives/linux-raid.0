From: "Kyle Harris" <kyle@theharrishome.com>
Subject: Mdadm recovery in infinite loop
Date: Tue, 12 Jun 2007 12:16:54 -0500
Message-ID: <000b01c7ad15$79d43fa0$0a01a8c0@kyle>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a problem with a software RAID-1 implementation on the Linux 2.6.9
kernel using mdadm.  The mdadm version is 1.12.0 and when I use yum with
Centos 4.4, it appears to be updated for this distro.  The array in question
showed as being degraded (I think that was the term it used).  I have had
this happen before on rare occasions where the drive is not actually bad,
but the software thinks it is.  I did some testing on the drive and turns
out it was fine.  Therefore, I ran the mdadm command to add the drive back
to the array.

Now, when I look at /proc/mdstat it shows that the array is recovering,
however when it hits 100 percent, it starts all over again.  How can I break
out of this loop?  I have already rebooted and that didn't help.  I can't
remove a drive from the array as it says it is busy.  The drives in question
are partitioned as Linux raid autodetect.  This particular array is mounted
as /.  Someone ask in another group if I was using watch to watch the
/proc/mdstat file and I am not.  Any other ideas?

Any help would be greatly appreciated. 





