From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: How to stress test an RAID 6 array?
Date: Mon, 03 Oct 2011 15:26:53 +0200
Message-ID: <4E89B81D.5000800@yazzy.org>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys.

After a rather long thread with many questions about my failed RAID 
array I'm trying to give it another shot.
I replaced all the SATA cables and I want to stress test my array.
Short description of what it was used for when it failed:
I had a 5 drive (5x2TB Seagate Green Barracuda) RAID 6 array with LVM on 
top of it.
- One of the LVs was serving as a samba storage
- One as a NFS exported storage with web sites
- 3 LVs had KVM hosts installed to them (heavy hammered web server, 
MySQL server and mail/imap/pop3 server)

The load seemed to have stressed my array/the HDs to the point when 3 of 
the drives were kicked off the array resulting in loss of data.
It's hard to find a cause of it - some forum threads on the Interner 
suggest it may be the kernel, some say it could be the SATA controller, 
the SATA cables and most of them suggest it's because of the hard drives.

Now I would like to stress test the array and see whether it would fail 
again or not. What would be the best way to do that?




-- 

Marcin M. Jessa
