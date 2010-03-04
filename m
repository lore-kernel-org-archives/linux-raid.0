From: "Ken D'Ambrosio" <ken@jots.org>
Subject: RAID MIA.  Again.  (Kinda.)
Date: Thu, 4 Mar 2010 11:12:29 -0500 (EST)
Message-ID: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey, all.  I had a problem a month or so ago where I had three mirrors,
and one of them went AWOL after a system migration.  Finally got as much
as I could back, created a RAID-5 of four of the 1.5 TB disks, put
everything on it, recovered more from backup, and was feeling pretty good.

Then the power went out.

Now, now RAID-5.  Or, rather, mdadm sees that there are RAID partitions,
and starts; fdisk shows me an unpartitioned disk.  Which is, essentially,
the exact same thing I had happen last time.  (Except that, this time, I
*know* my mdadm.conf is correct, because it hasn't changed -- but, for the
hell of it, I did a "mdadm --detail --scan", and it matches.)

WTF?  Am I too stupid for software RAID?  Is there something really
obvious I'm missing?  Any help at all would be most graciously accepted.

Thanks,

-Ken


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

