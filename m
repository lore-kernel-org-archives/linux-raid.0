From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: metadata 1.2
Date: Fri, 26 Mar 2010 20:43:52 +0100
Message-ID: <20100326194352.GA2474@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

quick question: what's the use case for metadata 1.2?

I read that the 4K offset is intended to leave space
for the MBR and bootloader, I assume.
The subtext here seems to be a partionless configuration
with RAID, but I'm not aware of any bootloader which
can boot from RAID and fit into 4K.

Clarifications?

Thanks a lot in advance,

bye,

-- 

piergiorgio
