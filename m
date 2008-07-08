From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch 0/8] simple md.c cleanups
Date: Tue, 8 Jul 2008 11:06:54 +1000
Message-ID: <18546.48558.451793.270407@notabene.brown>
References: <20080707075532.GA32617@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 7, maan@systemlinux.org wrote:
> Hi
> 
> here are eight simple cleanup patches to md.c against linus-current.git.
> Please review.

Thanks. I
 - added "md: " to the start of the subject line
 - fixed the conflicts with the first patch against my current tree:
     I think I already fixed some of that indenting
 - dropped the last patch....  I don't have a clear justification,
   but I currently want to leave the 'mddev' parameter there to remind
   me to review the implementation as I might want to do something
   a bit different there ... not sure yet.

They are now in my "for-next" branch which can be viewed at

 http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/for-next

NeilBrown
