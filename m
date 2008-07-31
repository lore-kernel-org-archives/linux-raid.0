From: aristizb@ualberta.ca
Subject: RAID1 write order fidelity
Date: Thu, 31 Jul 2008 09:03:30 -0600
Message-ID: <20080731090330.285131sc3ypxzwhu@webmail.ualberta.ca>
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

Hi,

I am currently working with a software Linux RAID1, with external  
bitmap and no write-behind option. Does the RAID controller keep the  
write order fidelity?.

If an application writes some blocks on the RAID device in a  
particular order, can I ensure that these blocks will be written to  
the devices conforming the RAID on the same order, or at least on the  
main disk? (disk 0 on the RAID).


The version of mdadm I am suing is 2.6.2.


Thank you.


Juan Aristizabal.
