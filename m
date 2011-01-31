From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 21:18:23 +0100
Message-ID: <20110131201823.GA15704@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

assuming there is a NAS, with, for example, 10 HDDs
in RAID-6. Assuming the HDDs are put in standby, in
order to save energy, when the NAS is not used.
How is the spin up sequence when the corresponding
/dev/mdX device is accessed?
Will the system spin up one HDD at time or all together?

Obviously, one at time will limit the peak current,
thus allowing a better dimensioned PSU, working almost
always around the optimal efficiency point.

Thanks a lot for any information on the topic,

bye,

-- 

piergiorgio
