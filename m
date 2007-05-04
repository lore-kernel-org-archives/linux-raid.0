From: Ruslan Sivak <rsivak@istandfor.com>
Subject: raid10 on centos 5
Date: Fri, 04 May 2007 12:22:11 -0400
Message-ID: <463B5DB3.6020502@istandfor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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


