From: "Riley Williams" <Riley@Williams.Name>
Subject: RE: Mirroring swap
Date: Thu, 26 Jun 2003 08:07:47 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BKEGKPICNAKILKJKMHCAEEFPEHAA.Riley@Williams.Name>
References: <Pine.LNX.4.44.0306251535120.16603-100000@gpu.utcc>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0306251535120.16603-100000@gpu.utcc>
To: Derek Yeung <dky@utcc.utoronto.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Derek.

 > I'm running Red Hat 9 on stock kernel 2.4.20 with software
 > RAID 1.
 >
 > I was wondering if it's a good idea to also mirror the swap
 > partition? I was reading old posts in the newsgroups that
 > suggest this may not be a good idea but I can't seem to find
 > an answer as to why. I think mirroring swap would be a good
 > idea as it would increase redundancy. Any thoughts?  

Personally, I can't see the point. the contents of swap are by
definition short term temporary data with copies held either in
memory or elsewhere on the hard disk subsystem.

My preference is to create multiple swap partitions, one on each
hard drive, as in that situation, the swap subsystem always uses
a swap partition on a different drive to the original copy when
it decides where to swap out to.

Remember that using a raided swap partition means that the swap
code has no idea which drive any particular part of that swap
partition is on, so could result in the swap copy being on the
same failed drive as the original copy.

Best wishes from Riley.
---
 * Nothing as pretty as a smile, nothing as ugly as a frown.

---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.491 / Virus Database: 290 - Release Date: 18-Jun-2003

