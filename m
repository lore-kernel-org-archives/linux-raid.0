From: Hari Bhaskaran <hbhaskaran@gmail.com>
Subject: raid-1 without marking partition as type "fd"
Date: Wed, 02 Nov 2005 18:57:24 -0800
Message-ID: <43697C94.3080400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am following rootraiddoc.97.html  howto and it suggests creating an 
"fd" (RAID) parition. I didn't do this and I still have a working raid-1 
bootable partition. I left the both partitions are regular "linux" and 
everything seems to work fine.
Isn't this a better approach than marking it "fd"? This way I can take 
one of the disks to a machine that knows nothing about raid and still 
read data. I know this might work only with raid-1. Am I missing something?

Any help is appreciated
--
Hari

