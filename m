From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Possible failure & recovery
Date: Mon, 10 Aug 2009 11:08:00 -0700
Message-ID: <4A806200.6010603@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not 100% certain about this...but maybe.

I had setup a small box as a remote backup for our company.  I THOUGHT I 
had set it up as a Raid-10 - but I can't swear to it now.  I just had a 
need to try to recover a file from that backup - only to find we just 
had an error.

Checking mdadm.conf, I find -
ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
devices=/dev/sda,/dev/sdb,/dev/sdc,/dev/sdd 
UUID=7ec24ccc:973f5065:a79315d0:449291b3 auto=part

Now, I do know that one of the drives had failed previously (sdd), and 
the array has been operating in degraded condition for some time.  Now 
it appears that a second drive failed.  I received XFS errors and only 
two drives showed under /proc/mdstat (sdb was removed as well as sdd).

xfs_check reported errors.  Whether or not it was a good idea, I tried 
adding sdb back to the array.  It worked and started rebuilding.  Then I 
noticed that the array was reporting as "raid6".  I don't know when it 
BECAME raid6, if I always had it as such or if the raid-10 somehow 
degraded and became raid-6.  If it actually did so - that might make for 
some type of a migration/expansion path for a raid-10 array that needs 
to grow.

My xfs_repair -L /dev/md0 process is currently running...I'm holding my 
breath to see how much I get back...
-- 
Daniel

