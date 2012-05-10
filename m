From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Superblock backup
Date: Thu, 10 May 2012 19:44:31 +0200
Message-ID: <20120510174431.GA3019@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

again, following the RAID-5 story, I was wondering
if could make sense to have a new superblock type,
let's say 2.x, having backup copies (of persistent
or quasi persistent data) in different areas of the
drive components.
This would be similar to filesystem or gpt.

Is there anything planned for this?

In any case, it would be still interesting to have
a "backup" capability at hand, like a "dd" of the
superblock to some secure file.

Any idea or suggestions?

Thanks,

bye,

-- 

piergiorgio
