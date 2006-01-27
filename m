From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: [PATCH 006 of 7] md: Checkpoint and allow restart of raid5 reshape
Date: Fri, 27 Jan 2006 13:37:45 +0100
Message-ID: <62b0912f0601270437p15c3466do3a879ba162169efa@mail.gmail.com>
References: <20060124112626.4447.patches@notabene> <1060124004117.5094@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060124004117.5094@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> We allow the superblock to record an 'old' and a 'new'
> geometry, and a position where any conversion is up to.

> When starting an array we check for an incomplete reshape
> and restart the reshape process if needed.

*Super* cool!
