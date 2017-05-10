From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Network based (iSCSI) RAID1 setup
Date: Wed, 10 May 2017 14:03:23 +0500
Message-ID: <20170510140323.256edb95@natsu>
References: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 May 2017 10:42:54 +0200
Gionatan Danti <g.danti@assyoma.it> wrote:

> even if in my preliminary tests this seems to work 
> reasonably well, do you feel that such solution can be used for 
> production workloads? Or something with a more specific focus, as DRBD, 
> remains the preferred solution?

First thing that comes to mind, you should look into setting the remote device
as --write-mostly, so that the local one is preferred for all reads (as long as
it's up).

But to be honest DRBD may indeed be a better solution for this use case, as
it's built specifically with it in mind, and likely has all the various
gotchas that might arise already thought about and handled properly.

-- 
With respect,
Roman
