From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid 5 Kernel Bug
Date: Fri, 23 Jul 2004 14:55:56 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16640.39516.764215.633076@cse.unsw.edu.au>
References: <200407221250.35040.knesmith@si2.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kevin A. Nesmith on Thursday July 22
To: "Kevin A. Nesmith" <knesmith@si2.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 22, knesmith@si2.org wrote:
> I am running SuSE Linux 9.1.  I have 8 SCSI harddrives all the same running raid 5.  It is just that simple.  
> Nothing more, no third party stuff.  No other raid running on this box.  The harddrive that the OS is running 
> on is an IDE at /dev/hda.  I386 AMD 900 MHZ 512 mg ram.  Any
thoughts?

I suspect this is a SuSE-specific bug.  They certainly had one just
like this in a recent 2.6 kernel.

NeilBrown
