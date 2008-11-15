From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: md.txt, preread_bypass_threshold and raid5: corrected error
Date: Sun, 16 Nov 2008 06:52:04 +1300
Message-ID: <491F0C44.9070403@sauce.co.nz>
References: <alpine.DEB.1.10.0811121144250.12675@p34.internal.lan> <e9c3a7c20811141700v736d7a3ep4362a96fc5afe90b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20811141700v736d7a3ep4362a96fc5afe90b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan Williams wrote:

> By default MD tries to be fair and allow partially written stripes the
> same access to the disk as fully written stripes to prevent starvation
> for little writers.  However, you can sometimes eek out more streaming
> performance at the cost of fairness by increasing this value (where 0
> == never let a preread pass a full-stripe-write).

I believe XFS optimises for full stripe writes, so perhaps this setting 
is of more benefit for other file systems?

As always I guess, real world testing is the only answer.

Regards,

Richard
