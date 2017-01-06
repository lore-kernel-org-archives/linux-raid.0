From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Recommendation on new system Arrays
Date: Fri, 6 Jan 2017 10:14:17 -0600
Message-ID: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey guys,


 I have a question for you now that I'm diving into a machine with more drives on a single system than I've ever worked with before.


Hardware:

    Supermicro Rack PC with Avago MegaRAID SAS 9380-8e HBA. Motherboard has Dual Xeon E5-2640 V4 cpus (10 HT cores each)

    Supermicro SC847 JBOD housing with room for 44 disk but currently populated with 22 drives (rear backplane)

    (22) HGST 8TB drives - Model HUH728080AL5200 - https://www.hgst.com/products/hard-drives/ultrastar-he8

    OS is CentOS 7.x (I think 7.2. I just downloaded and installed the other night)

Of course, I'd like to avoid HW raid.

but.. for this array, I was going to split into a couple of RAID6 arrays with a couple hot spares in the rack.

    * one for owners data

    * the other as a data drive for use with surveillance software (from Milestone probably) running in a VM as a secondary storage vault for company cameras/NVRs that are remote. (like a backup system)

But anything else I should look out for?

Thanks,

 -Ben

