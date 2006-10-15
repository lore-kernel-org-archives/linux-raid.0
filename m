From: "Dan" <dan@korstad.net>
Subject: FW: Multiple Disk Failure Recovery
Date: Sun, 15 Oct 2006 06:51:10 -0500
Message-ID: <000101c6f050$36c41d70$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


One could remove the spare drive from the system.  Than do the mdadm
--assemble --force to get it start and keep it from trying to
resync/recover.

Once you get the array up and 'limping' carefully pick the most important
stuff and copy it off the array and hope the bad sectors don't did not
affect that data.  As you mentioned, you have bad sectors.  If you try to do
it all or even as you pick the important stuff (I know it is all important
that why it was on the RAID), you will eventually hit data that has bad
sectors and mdadm will fail the effected drive and deactivate the array.  At
that point accept that the data in that area is most likely gone. Than do
the mdadm --assemble --force to get it started again and move on to the next
areas of most important data.  Could be a long cycle...

Aside from that, I am curious, was your spare disk shared by another array.
If it was not than I would recommend you don't do a RAID5 with hot spare
next time, and do a RAID6.  But this is my person feeling and you can take
it or leave it.

I too at one point did a RAID5 with hot spare and I was using eight drives.
So yes you can have two drives fall as long as the delta between failures is
long enough to allow the raid to resync the spare in and during the process
there are no be unknown bad sectors on the remaining drives.  But I got to
thinking, if I am going to be spinning/powering that "hot spare" I may as
well as do a RAID6.  As long as the hot spare is not share with other
arrays, I see no downside and it would protect you in the future from this
problem.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Lane Brooks
Sent: Saturday, October 14, 2006 9:29 PM
To: linux-raid@vger.kernel.org
Subject: Multiple Disk Failure Recovery

I have a RAID 5 setup with one spare disk.  One of the disks failed, so 
I replaced it, and while it was recovering, it found some bad sectors on 
another drive (unreadable and uncorrectable SMART errors).  This 
generated a fail event and shut down the array.

When I restart the array with the force command, it starts the recovery 
process and dies when it gets to the bad sectors, so I am stuck in an 
infinite loop.

I am wondering if there is a way to cut my losses with these bad sectors 
and have it recover what it can so that I can get my raid array back to 
functioning.  Right now I cannot get a spare disk recovery to finish 
because these bad sectors.  Is there a way to force as much recovery as 
possible so that I can replace this newly faulty drive?

Thanks
Lane
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



