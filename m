From: Tom Eicher <tom.eicher@gmx.ch>
Subject: entire array lost when some blocks unreadable?
Date: Tue, 07 Jun 2005 22:56:58 +0200
Message-ID: <42A60A1A.9030302@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I might be missing the point here... I lost my first Raid-5 array 
(apparently) because one drive was kicked out after a DriveSeek error. 
When reconstruction startet at full speed, some blocks on another drive 
appeared to have uncorrectable errors, resulting in that drive also 
being kicked... you get it.

Now here is my question: On a normal drive, I would expect that a drive 
seek error or uncorrectable blocks would typically not take out the 
entire drive, but rather just corrupt the files that happen to be on 
those blocks. With RAID, a local error seems to render the entire array 
unusable. This would seem like an extreme measure to take just for some 
corrupt blocks.

- Is it correct that a relatively small corrupt area on a drive can 
cause the raid manager to kick out a drive?
- How does one prevent the scenario above?
  - periodically run drive tests (smart -t...) to early detect problems 
before multiple drives fail?
  - periodically run over the entire drives and copy the data around so 
the drives can sort out the bad blocks?

Thanks for any insight, tom
