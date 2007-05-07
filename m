From: raider@computeca.com
Subject: RAID defns
Date: Mon, 7 May 2007 20:08:06 GMT
Message-ID: <20070507200806.25D5A586D4@computeca.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: raider@computeca.com
List-Id: linux-raid.ids

Sorry for the rookie question, but I'm looking for clarity
with regard to some software RAID terms that different sites
and people seem to confuse with each other.  I'm wondering
if I've been using the wrong terms all along?

Are these correct?

Stripe width = number of devices in the RAID array (or is it number of
bytes in one stripe across all RAID devices?)

Chunk size = the smallest amount of data that can be written to each device
in the RAID stripe (mdadm's "--chunk" parameter)

Stripe size = the number of chunks to put on each device in one pass
through the stripe (mdadm's "--size" parameter)

Stride = the number of filesystem blocks, per single stripe across all
devices.  

So...  (--chunk=32kiB)*(--size=4)*(stripe width of 3) = (stride of 96)
assuming 4kiB fileystem blocks?

Any clarity would be much appreciated.  Thanks,

-Marc


