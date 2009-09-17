From: aristizb@ualberta.ca
Subject: SET_BITMAP_FILE assembling raid1
Date: Thu, 17 Sep 2009 16:07:18 -0600
Message-ID: <20090917160718.15831qsk0zd6k2e8@webmail.ualberta.ca>
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

After have stopped a raid1, I try to assemble it with one device and  
its bitmap; but I received the following error message:

$mdadm --assemble --force /dev/md2003 --bitmap=/tmp/md2003bm  
/dev/syntropy21/ian_dvol_200_0_1

mdadm: SET_BITMAP_FILE failed.

After 5 minutes I retry the command and it succeeds, assembling the  
raid without any problems.


It looks like mdadm cannot use the file I specified for the external  
bitmap, but this file is not in use by any other raid. Is there any  
explanation on why assemble could fail to create the raid with the  
specified bitmap?


Thank you.



Juan.
