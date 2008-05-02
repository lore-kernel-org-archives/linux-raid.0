From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH] md: fix raid5 'repair' operations
Date: Fri, 02 May 2008 12:24:47 -0400
Message-ID: <20080502162447.13832.qmail@science.horizon.com>
References: <20080502031513.13090.2973.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080502031513.13090.2973.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, dan.j.williams@intel.com
Cc: linux@horizon.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just to confirm, after 2 hours repair + 2 hours check, it seems to have
worked.  And the e2fsck didn't complain.

So if you think it's good, please submit for 2.6.25.2.
