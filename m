From: Chris Allen <chris@cjx.com>
Subject: Recovering a raid5 array with strange event count
Date: Fri, 13 Apr 2007 11:14:26 +0100
Message-ID: <461F5802.4090608@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear All,

I have an 8-drive raid-5 array running under 2.6.11. This morning it 
bombed out, and when I brought
it up again, two drives had incorrect event counts:


sda1: 0.8258715
sdb1: 0.8258715
sdc1: 0.8258715
sdd1: 0.8258715
sde1: 0.8258715
sdf1: 0.8258715
sdg1: 0.8258708
sdh1: 0.8258716


sdg1 is out of date (expected), but sdh1 has received an extra event.

Any attempt to restart with mdadm --assemble --force, results in an an
un-startable array with an event count of 0.8258715.

Can anybody advise on the correct command to use to get it started again?
I'm assuming I'll need to use mdadm --create --assume-clean - but I'm 
not sure
which drives should be included/excluded when I do this.


Many thanks!


Chris Allen.



