From: "Ruth Ivimey-Cook" <Ruth.Ivimey-Cook@ivimey.org>
Subject: Messed up creating new array...
Date: Fri, 8 Sep 2006 15:04:24 +0100
Message-ID: <001201c6d34f$b0651710$0e00a8c0@sherlock>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

I messed up slightly when creating a new 6-disk raid6 array, and am wondering
if there is a simple answer. The problem is that I didn't partition the drives,
but simply used the whole drive. All drives are of the same type and using the
Supermicro SAT2-MV8 controller.

This is a problem because mdadm doesn't find the component drives... I can only
start the array by using "mdadm --assemble /dev/md3 /dev/sd{drives}". While
this works it means my system doesn't boot very easily :-(

For fixes I can think of the possible solutions:

 - Modify the startup script to do the mdadm --assemble /dev/md3
/dev/sd{a,b,c,d,e}. Is there any other disadvantage of this?

 - Use fdisk to create whole-disk partitions - but would this damage the
already stored data?

 - Start again doing it right.... But this will take >12 hours and has a chance
of failure!

Any thoughts?

Regards,

Ruth

