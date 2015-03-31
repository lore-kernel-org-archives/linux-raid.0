From: stkoupr <p.kouril@cra.cz>
Subject: multi-threaded raid5
Date: Tue, 31 Mar 2015 19:17:34 +0200
Message-ID: <551AD6AE.4030607@cra.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We are testing write performance of md raid5 with SSD array and we are 
hitting limit which I understand is caused by writes being handled in 
single thread (md0_raid5 process is eating 100% of 1 CPU core when the 
test is running). I understood that there is some work in progress which 
should make write handling multi-threaded. I'd like to ask about the 
status of this work, is it still in progress or planned?

Regards,
Prema
