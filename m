From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: deprecating /proc/mdstat (was: Re: mdadm bad blocks list)
Date: Thu, 28 Jan 2016 12:41:21 +0100
Message-ID: <20160128124121.Horde.YKtbZL0CUYKTuEkxLcmmhQ4@www3.nde.ag>
References: <56A9102D.4030304@prgmr.com>
 <87twly1jc7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87twly1jc7.fsf@notabene.neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil & *,

Zitat von NeilBrown <nfbrown@novell.com>:
> [...]
> I'd like to deprecate /proc/mdstat.  It is not really easy to extend.

while I understand that /proc/mdstat's format might be considered  
"frozen" as in "do not confuse old scripts by new formats", I'd hate  
to see /proc/mdstat go away without a similar replacement: calling  
"mdadm" (or any other CLI) to gather that information is unruly  
expensive when all you have to do is "watch cat /proc/mdstat" to  
manually monitor critical operations.

> I'd recommend using "mdadm" to get status of an array, or examine file
> in /sys.

If there's to be a "new mdstat" in /sys, I'd be fine with that. That  
would help migration for those "old scripts grep'ing /proc/mdstat" you  
rightfully care about.

I suggest to include a file format version information on line 1  
"/sys/.../mdstat", that way any client parsing such an interface could  
verify the file format first, and bail out if it doesn't support the  
currently presented format.

With regards
Jens

