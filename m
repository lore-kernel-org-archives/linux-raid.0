From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH md 005 of 10] Split off some md attributes in sysfs to a separate group.
Date: Wed, 2 Nov 2005 13:48:10 -0800
Message-ID: <20051102214810.GG23247@kroah.com>
References: <20051102205640.22689.patches@notabene> <1051102101516.23901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051102101516.23901@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2005 at 09:15:16PM +1100, NeilBrown wrote:
> 
> Some, but not all, md array support data redundancy and hence
> support checking and restoring that redundancy (resync, rebuild).
> 
> Some attributes apply specifically to functions involving this
> redundancy, and so should only appear for md arrays for which they
> are meaningful.  i.e. they should not appear for raid0, linear, multpath,
> faulty.
> 
> This patch separates these into a distinct group and creates
> the group only if the personality supports sync_request.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
