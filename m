From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: write barriers on raid0 and raid10
Date: Tue, 08 Jun 2010 14:23:04 -0400
Message-ID: <4C0E8A88.8010906@cdf.toronto.edu>
References: <S1751539Ab0FHSI6/20100608180858Z+3813@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1751539Ab0FHSI6/20100608180858Z+3813@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We are designing a rather involved file server with an ext3 formatted 
stripe (raid0) sitting on top of raid10 devices. Each raid10 device sits 
on top of 3 iscsi targets, and has layout n3 (so it is effectively a 3 
way mirror). We chose raid10 over raid1 due to an apparent read 
performance benefit of raid10.

We are trying to decide whether to upgrade to a kernel newer than 
2.6.34, where write barriers are ostensibly supported by all possible 
raid types, because we are worried about ext3 corruption with no write 
barrier support.

However, we are also worried about whether write barriers really "make 
sense" in a multi-disk environment and are wondering whether they will 
actually make a difference in our setup. For argument's sake, let's 
assume that our drives honor write cache flushes.

Can somebody shed some light on how write barriers are implemented in 
raid0 and raid10? Also, any critical comments on the validity of our 
setup and/or assumptions is also welcome.

Many thanks!
Iordan Iordanov
