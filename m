From: AndyLiebman@aol.com
Subject: udev and mdadm -- I'm lost
Date: Tue, 8 Nov 2005 18:21:59 EST
Message-ID: <1b9.203c2461.30a28d17@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry to pose this question but a  search through "man mdadm" the linux-raid 
archives and google didn't really get  me a very satisfactory answer. 

I guess I'm accustomed to working on  Linux systems with devfs. But now I had 
to upgrade to a distribution with udev.  I didn't notice any issues with 
mdadm until today, when I was working on a  server that was going to have two 
separate Software RAID-0 arrays (each striping  two 3ware Hardware RAID-5s). 

Lo and behold, I got the "/dev/md1 doesn't  exist" error when I tried to 
assemble /dev/md1. 

I see there is an mdadm  --auto option now, but I don't feel confident I know 
how to use it. Can someone  tell me the correct way to create or assemble an 
array with the --auto option?  

I don't want to do anything fancy. I don't need partitionable RAIDS. Do  I 
HAVE to specify a device number? 

It would just be nice to have a  couple of concrete examples of the proper 
syntax in "man mdadm"

If you  see this, Neil, I think you do a fantastic job. I'm sorry to ask this 
basic  question, but just one example in the manual would be welcome. I am 
using mdadm  1.9.0 and don't see one. 

i.e, 

mdadm -Av -a1 --uuid=xxxxx  /dev/sd*
or 
mdadm -Av -a /dev/md1 --uuid=xxxxx /dev/sd*

I'm not in  the mood to guess... 

Thanks. 

Andy Liebman  

