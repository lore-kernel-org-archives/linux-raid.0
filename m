From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for April 21 (md/raid456)
Date: Thu, 21 Apr 2011 07:41:13 -0700
Message-ID: <20110421074113.5a0410fc.randy.dunlap@oracle.com>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110421132045.5af1b953.sfr@canb.auug.org.au>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:

> Changes since 20110420:


on i386:

ERROR: "__udivdi3" [drivers/md/raid456.ko] undefined!

in raid45_takeover_raid0()

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
