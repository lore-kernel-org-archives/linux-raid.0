From: Bin Ren <br260@cam.ac.uk>
Subject: raid1_conf_t member meanings
Date: Mon, 5 Jan 2004 11:58:14 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <71331E50-3F76-11D8-8AD6-000A9576014E@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v609)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm reading the source codes of RAID1. In file 
'include/linux/raid/raid1.h',
in struct raid1_private_data, there are these members:

unsigned long start_active, start_ready, start_pending, start_future;
int cnt_done, cnt_active, cnt_ready, cnt_pending, cnt_future;

Could anybody tell me the meaning of 'active, ready, pending, future' 
and
'cnt_done'?

Thanks a lot.
Bin

