From: Brendan Hide <brendan@swiftspirit.co.za>
Subject: vulnerability during partition-size-growth procedures
Date: Mon, 23 Jul 2012 07:45:47 +0200
Message-ID: <500CE50B.5010201@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

In the wiki 
(https://raid.wiki.kernel.org/index.php/Growing#Expanding_existing_partitions) 
there's mention of increased vulnerability to failure when growing an 
array because disks have to be failed before additional disks can come 
into play.

Are there plans to allow a disk migration/clone feature in future? If 
not having this feature built-in, would dd (or GNU ddrescue) perhaps be 
used to do this manually? The only down side I can see to doing it 
manually is that it would likely require downtime. See below.

2-disk RAID0 (Simplest for illustration purposes, also impossible to do 
with current procedure):
02468AC <- disk0
13579BD <- disk1

Introduce a new larger disk intended to replace disk1 and sync the data 
across:
02468AC <- disk0
13579BD <- disk1
13579BD------- <- disk2

Fail/remove disk1:
02468AC <- disk0
13579BD------- <- disk2

The current procedure has us degrade the array before we put any data 
onto the larger disk2.

-- 
Brendan Hide

+27 83 448 3867
http://swiftspirit.co.za/

