From: Brad Campbell <brad@wasp.net.au>
Subject: Information gathering script
Date: Wed, 24 Mar 2010 23:10:13 +0800
Message-ID: <4BAA2B55.8040504@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

Having just dropped a drive (it turns out 1TB SATA drives don't bounce) that belonged in my 10 drive 
RAID-6 and having replaced it this afternoon, I had a thought.

When things go wrong (particularly those nasty things that cause the sick feeling in the pit of your 
stomach) the best help is always available give the right information.

If there was a script that one could run when things were healthy that dumped all the relevant 
information for safe keeping, would it reduce the nightmare that is recovering a broken raid?

I'd imagine an mdadm --examine on each component of a RAID, partition tables and perhaps a --detail 
on each md device. Is there anything else that might be handy that could be dumped to a verbose 
output just in case?

Is there already such a thing?

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
