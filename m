From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: Preventing a RAID device from starting until all disks are ready
Date: Thu, 14 Oct 2010 12:00:42 -0400
Message-ID: <4CB7292A.6040209@cdf.toronto.edu>
References: <385159.62204.qm@web65412.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <385159.62204.qm@web65412.mail.ac4.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

Andrew Klaassen wrote:
> During boot, mdadm starts the array before one of the two fibre-channel cards has started its disk detection.  The array comes up, but with only 28 of 56 drives, and I have to manually re-add the drives and cross my fingers that nothing will go wrong during the 10-hour rebuild.

Have you considered enabling a write-intent bitmap on your array? This 
way, at least your rebuild will take seconds instead of 10 hours. Write 
intent bitmap support for RAID10 was introduced in 2005, and hopefully 
CentOS 5.2 supports it.

> Is there any way to tell mdadm to wait longer, or to not attempt to start the array if not all devices are present, or... (any other solution you can think of)?

We have iscsi targets for drives in our array, and we make sure that 
we've logged into all 30 of our drives before we continue to enable 
mdadm (we literally count the number of iscsi sessions open). You can 
try counting the number of block devices present (in /dev/block) that 
match a certain pattern, or perhaps your fiber channel driver offers an 
even more convenient facility in /dev.

However, it would be great if there really was a way to tell mdadm to 
wait until the devices are ready. I'm not aware of one though.

Cheers!
Iordan
