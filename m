From: Steve Costaras <stevecs@chaven.com>
Subject: mdadm / force parity checking of blocks on all reads?
Date: Thu, 17 Feb 2011 20:04:48 -0600
Message-ID: <4D5DD3C0.3020804@chaven.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



I'm looking at alternatives to ZFS since it still has some time to go 
for large scale deployment as a kernel-level file system (and brtfs has 
years to go).   I am running into problems with silent data corruption 
with large deployments of disks.    Currently no hardware raid vendor 
supports T10 DIF (which even if supported would only work w/ SAS/FC 
drives anyway) nor does read parity checking.

I am hoping that either there is a way that I don't know of to enable 
mdadm to read the data plus p+q parity blocks for every request and 
compare them for accuracy (simlar to what you need to do for a scrub but 
/ALWAYS/) or have the functionality added as an option.

With the current large capacity drives we have today getting bit errors 
is quite common (I have some scripts that I do complete file checks 
every two weeks across 50TB arrays and come up with errros every 
month).   I'm looking at expanding to 200-300TB volumes shortly so the 
problem will only get that much more frequent.     Being able to check 
the data against parity will be able to find/notify and correct errors 
at read time before they get to user space.   This fixes bit rot as well 
as torn/wild reads/writes and mitigates transmission issues.

I searched the list but couldn't find this benig discussed before, is 
this possible?

Steve Costaras
stevecs@chaven.com
