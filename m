From: <Patrick_Boyd@Dell.com>
Subject: RE: raid10 on centos 5
Date: Fri, 4 May 2007 11:50:49 -0500
Message-ID: <CE7B1A4EF22E704CBFFD9A35BA5C82221E00D2@ausx3mpc110.aus.amer.dell.com>
References: <463B5DB3.6020502@istandfor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <463B5DB3.6020502@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: rsivak@istandfor.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No LVM over the two RAID 1's is more like RAID 1c which is just a
concatenation of RAID 1's. You don't get the striping that you get in
RAID 10.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ruslan Sivak
Sent: Friday, May 04, 2007 11:22 AM
To: linux-raid@vger.kernel.org
Subject: raid10 on centos 5

I am trying to set up raid 10 and so far with no luck.  I have 4 drives,

and Anaconda will not let me do raid 10.  mdadm doesn't have the raid 10

personality loaded.  When I create the array manually like so:

2 drives in /dev/md11 as raid1
2 drives in /dev/md12 as raid1
md11 and md12 in /dev/md10 as raid0

Everything looks fine from the shell, but anaconda only sees md11 and 
md12. 

The only choice I see is to set up LVM over md11 and md12.  Is this 
really raid10?

Russ


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
