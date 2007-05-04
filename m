From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Raid1 replaced with raid10?
Date: Fri, 04 May 2007 14:54:45 +0200
Message-ID: <463B2D15.7020305@rabbit.us>
References: <45FF1BDF.6060304@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45FF1BDF.6060304@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I asked this question back in march but received no answers, so here it
goes again. Is it safe to replace raid1 with raid10 where the amount of
disks is equal to the amount of far/near/offset copies? I understand it
has the downside of not being a bit-by-bit mirror of a plain filesystem.
Are there any other caveats?

Thanks

Peter
