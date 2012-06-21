From: Phillip Susi <psusi@ubuntu.com>
Subject: resizing array devices not working?
Date: Thu, 21 Jun 2012 11:19:37 -0400
Message-ID: <4FE33B89.40007@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was trying to do a little experiment with resizing devices.  I created 
two 1g logical volumes and built a raid1 array out of them, then 
lvresized the volumes to 2g, then ran:

mdadm -G -z max /dev/md1

That SHOULD expand the array to use the extra space right?  It keeps 
telling me that it set the size to just 1g.
