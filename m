From: Ian Whitton <boyfromthedwarf9@gmail.com>
Subject: MDADM RAID5 listing active drives as spares
Date: Wed, 29 Jun 2011 09:55:30 -0400
Message-ID: <50550841-1FDC-4143-82E7-5F897B8B6E21@gmail.com>
References: <S1753465Ab1F2Neh/20110629133437Z+882@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1753465Ab1F2Neh/20110629133437Z+882@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a mdadm RAID5 of 6 sata drives that was working fine until about a week ago when it was getting slow reads, but wrote fine.  After some looking around, and help on IRC, we figured it was the sata card I had of the drives on.  When I plugged the new card in, it was working, and rebuilding.  I woke up this morning and it seems something happened and now 2 drives are listed as spares.  I did start the raid with --assemble --force after putting the new card in.

This is a pastebin of mdadm --examine --scan and mdadm --examine /dev/sd[bcdefg]1
http://pastebin.com/ZR2cB46Q