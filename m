From: Mirko Benz <mirko.benz@web.de>
Subject: NVRAM support
Date: Fri, 10 Feb 2006 10:01:09 +0100
Message-ID: <43EC5655.1060504@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Does a high speed NVRAM device makes sense for Linux SW RAID? E.g. a PCI 
card that exports battery backed memory.
Could that significantly improve write speed for RAID 5/6 (e.g. via an 
external journal, asynchronous operation and write caching)?

What changes would be required?

Thanks,
Mirko
