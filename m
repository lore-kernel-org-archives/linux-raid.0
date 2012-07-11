From: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Subject: Re: mdadm-3.2.5: segfault in "--grow --continue"
Date: Wed, 11 Jul 2012 13:15:38 +0200
Message-ID: <0A5D7060-7727-4CBD-A1D7-34ED7D9747BC@tu-dresden.de>
References: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de> <20120710230205.171ee562@notabene.brown> <BC57DF1E-7CA3-429E-8935-44A94003B5E5@tu-dresden.de> <20120711122626.51cf7070@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711122626.51cf7070@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, 681056@bugs.debian.org
List-Id: linux-raid.ids

Hi!

Am 11.07.2012 um 04:26 schrieb NeilBrown:
> I should have asked which kernel you were running.  
> I'm guessing that it is earlier than 2.6.25, and so is missing upstream commit
>   25156198235325805cd7295ed694509fd6e3a29e
> 
> that fixes a bug which causes reshape not to restart if array was assembled auto-read-only.
The system is running vanilla 3.4.4, actually. So maybe there's another code path where this is missing...

Thank you four your help. My RAID6 arrays are up again, and all data is still there.


Yours,
Sebastian