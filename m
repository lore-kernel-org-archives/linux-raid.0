From: Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de>
Subject: raid and power off savety
Date: Tue, 22 Mar 2005 12:29:57 +0100
Message-ID: <76592C4D3DA1AC4FB8424084D10D31A806115268@mchh2c4e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am sorry for having to ask a question you might rate very stupid,
but I really want to know it: 

If you think through system crash scenarios, what types of chrashes 
are you are thinking of? Do you only consider harddisk faults, or 
do you consider power failures as well?

Or more extreme: Does RAID gives you savety on HD HW failures, but may
make things worse for power failures (hard power switch off)?

Or more academic: Does raid have some journaling of its dirty cache 
(and/or whatever would need to be journaled) in a non volatile way,
or isn't there any need for it for any tricky reason?

thomas
