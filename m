From: "Aggarwal, Vikas" <Vikas.Aggarwal@cavium.com>
Subject: Multithread raid5: Is check-for-completions also multithreaded (using
 async_xor) ?
Date: Thu, 9 Jun 2016 10:55:51 +0000
Message-ID: <CO2PR0701MB1031757BA3BABB368FEC9FAEF05F0@CO2PR0701MB1031.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello All,
With multithread raid5 enabled (echo 48 > /sys/block/md51/md/group_thread_cnt)  what I understand is that all the cpu cores will be able to submit   async_xor  instructions in parallel for a single md raid5  device.

Question: About polling for completion, is that also multi-threaded ? - Does the same number of worker threads (48 in my test) will continue poll for XOR completion as well ? 
My multi-core SoC  has  XOR/GF offload channel, and I am trying to see how to get the best throughput for raid5 rebuild using multithread functionality.

Regards
Vikas Aggarwal
