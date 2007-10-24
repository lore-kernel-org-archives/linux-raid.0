From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [lvm-devel] [PATCH] lvm2 support for detecting v1.x MD superblocks
Date: Wed, 24 Oct 2007 01:44:35 +0100
Message-ID: <20071024004435.GD10006@agk.fab.redhat.com>
References: <170fa0d20710230832v3313d38fmc646d89c1b990252@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <170fa0d20710230832v3313d38fmc646d89c1b990252@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LVM2 development <lvm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 23, 2007 at 11:32:56AM -0400, Mike Snitzer wrote:
> I've tested the attached patch to work on MDs with v0.90.0, v1.0,
> v1.1, and v1.2 superblocks.
 
I'll apply this, thanks, but need to add comments (or reference) to explain
what the hard-coded numbers are:

	sb_offset = (size - 8 * 2) & ~(4 * 2 - 1);
etc.

Alasdair
-- 
agk@redhat.com
