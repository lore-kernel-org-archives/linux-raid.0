From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 00:10:04 +0100
Message-ID: <20130127231004.6C4082033CC@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <CA3C3BC1-A00A-422B-A643-D5323FDC3F6A@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CA3C3BC1-A00A-422B-A643-D5323FDC3F6A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris Murphy,

In message <CA3C3BC1-A00A-422B-A643-D5323FDC3F6A@colorremedies.com> you wrote:
> 
> Well, you have a block on each drive that's supposed to be identical,
> and if there's a mismatch that means they're not identical and it's
> ambiguous which one is correct. So if the data on the drives is
> unimportant to retrieve correctly, then I guess it's not a critical
> error.

Heh, would I be running a RAID 6 array if the data was unimportant?

> What's the smartctl -a look like for all drives? I imagine one or more
> have bad sectors, ECC errors, or UDMA/CRD errors.

I see a some Hardware_ECC_Recovered; very few disks have 1
Reallocated_Sector_Ct; there are no (0) Current_Pending_Sector,
Offline_Uncorrectable, UDMA_CRC_Error_Count, Multi_Zone_Error_Rate, or
Data_Address_Mark_Errs.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
If God wanted me to touch my toes, he'd have put them on my knees.
