From: Erich Weiler <weiler@soe.ucsc.edu>
Subject: mdadm on huge raid sets
Date: Tue, 22 May 2007 12:51:21 -0700
Message-ID: <465349B9.3030702@soe.ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings all-

Quick question.  We've got one of these new Sun x4500's, it is basically 
a machine with 48 disks in it, no hardware RAID controller, so you have 
to use software RAID, in our case mdadm because we're running RHEL 4.4.

When we try to create the raid set (RAID6), we're getting an error: 
"Invalid number of devices" (47 devices).  We tried lowering the number, 
and eventually it worked when we brought the number down to 27.  But 
looking at the source code, it looks like it supports up to 256 devices 
for RAID6... ?  Any insight would be much appreciated!!

Thanks a million,
-erich
