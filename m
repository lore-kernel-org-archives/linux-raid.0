From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Raid and badblocks
Date: Tue, 26 May 2009 08:27:23 -0700
Message-ID: <1243351643.11073.29.camel@cichlid.com>
References: <gv5q3p$vof$1@ger.gmane.org> <gv5qnk$1pe$1@ger.gmane.org>
	 <77f027ed892f0a37b3df63d574ae7955.squirrel@neil.brown.name>
	 <gvgp32$9se$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gvgp32$9se$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-05-26 at 13:59 +0100, Jeremy Sanders wrote:

> Strangely, the Reallocated_Sector_Ct is still zero on the drive even though 
> Current_Pending_Sector is now zero. This is a Samsung HD103UJ by the way.

That can be ok. It probably tried writing and then rereading and when
that worked it decided the sector didn't really have a 'hard' error
(like a physical defect on the platter) and thus didn't need to be
reallocated to a spare sector. You could generate an unreadable sector
during a write by the power failing or with excessive vibration.

That said, the drive firmware could also be broken

