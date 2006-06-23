From: Nix <nix@esperi.org.uk>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 20:48:08 +0100
Message-ID: <87r71fk613.fsf@hades.wkstn.nix>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.tblclqd3cigqcu@apollo13> (PFC's message of "23 Jun 2006 09:58:08 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Jun 2006, PFC suggested tentatively:
> 	- ext3 is slow if you have many files in one directory, but has
> 	more mature tools (resize, recovery etc)

This is much less true if you turn on the dir_index feature.

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
