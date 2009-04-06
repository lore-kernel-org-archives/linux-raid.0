From: LCID Fire <lcid-fire@gmx.net>
Subject: Recreate raid 10 array
Date: Mon, 06 Apr 2009 21:49:58 +0200
Message-ID: <49DA5CE6.7030902@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On my raid10 array (4 drives) I've had 2 drives (the same model) which 
got disconnected by the kernel (almost at the same time). It seems like 
both were one raid1 part so one half of the raid0 is missing.
Afterwards I tried to readd the drives again (my bad) so now I'm stuck 
with 1 half of the raid0 part being present and valid and the other (2 
drives) marked as spare.
The thing I'd like to do is:
- Take 2 new drives (different manufacturers)
- Clone one of the valid and one of the spare drives to the new drives
- Try to reassemble the array.
Problem is - is this even possible?
How do I tell mdadm to not care about the spare state?
Does the kernel write bogus data to the still valid drives if the other 
2 fail?

Would be great if someone could enlighten me ;)

P.S.: Does someone know how to easily report the different sata errors 
which the kernel encounters?

