From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: stripe cache question
Date: Thu, 24 Feb 2011 22:06:43 +0100
Message-ID: <20110224210642.GA20306@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

few posts ago was mentioned that the unit of the stripe
cache are "pages per device", usually 4K pages.

Questions:

1) Does "device" means raid (md) device or component
device (HDD)?

2) The max possible value seems to be 32768, which
means, in case of 4K page per md device, a max of
128MiB of RAM.
Is this by design? Would it be possible to increase
up to whatever is available?

Thanks,

bye,

-- 

piergiorgio
