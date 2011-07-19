From: Mike Power <mpower@dodtsair.com>
Subject: RAID 1 using SSD and 2 HDD
Date: Tue, 19 Jul 2011 11:15:22 -0700
Message-ID: <4E25C9BA.1060401@dodtsair.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is it possible to implement a RAID 1 array using two equal size HDD and 
one smaller and faster SSD.  The idea being that the resulting RAID 
would have the same size of the HDD while picking up the speed benefits 
of the SSD.  You can do something similar today by just buying two 
hybrid drives and putting them in an array.  By purchasing a dedicated 
SSD drive for that purpose you gain the ability of controlling the size 
of the SSD portion.  I was hoping the RAID array could use the SSD more 
as a cache then a redundant storage.

Mike Power
