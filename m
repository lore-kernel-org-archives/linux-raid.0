From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 11:48:49 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1107181143440.8811@xavius.local>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j012fa$6k6$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Jul 2011, David Brown wrote:

First, I'd like to say that I've done more testing, and found that even 
after very prolonged, sustained heavy use, the (Intel 510) SSDs I 
partitioned 50/50 with half left unused didn't show any degradation in 
performance. That's after about a week of constant writing/erasing.

> If your disks are reasonably full, then TRIM will not help much because the 
> garbage collection will be desperately trying to piece together small bits 
> into complete erase blocks, and your performance will drop through the floor.

However, it won't drop as low as it would without TRIM in the same 
situation. But with a continuous heavy workload, even TRIM won't help, and 
over-provisioning is the way to go.

Best,

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 18/07/2011 : The Moon is Waning Gibbous (83% of Full)
