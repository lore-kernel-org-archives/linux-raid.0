From: aristizb@ualberta.ca
Subject: raid disappearing   mdadm: cannot get array info
Date: Tue, 15 Sep 2009 11:34:14 -0600
Message-ID: <20090915113414.182528qq5c675mhw@webmail.ualberta.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

I have several raids created on my Linux box and one of them has  
disappeared from /proc/mdstat.

The devices part of this raid are logical volumes and work fine.

When I try to fail one of the devices from the raid I get the  
following message:
$mdadm /dev/md1744 --fail /dev/storage/disk1

mdadm: cannot get array info for /dev/md1744


This message is different form the one you get when the raid has not  
been created:
mdadm: error opening /dev/mdXX: No such file or directory.

So md1744 must still in some sense, even though it was not listed in  
/proc/mdstat

The system where I hit this problem has enough RAM and is not being  
heavily utilized.


I am using mdadm version 2.6.3 on Ubuntu kernel 2.6.24-24.


Any ideas on this issue are highly appreciated.


Juan Aristizabal
