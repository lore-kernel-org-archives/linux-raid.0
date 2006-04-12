From: Neil Brown <neilb@suse.de>
Subject: Re: failed to RUN_ARRAY, input/output error
Date: Wed, 12 Apr 2006 18:33:37 +1000
Message-ID: <17468.47969.652243.826774@cse.unsw.edu.au>
References: <54490.84.236.149.243.1144790548.squirrel@www.navtek.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from johnny@navtek.no on Tuesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: johnny@navtek.no
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 11, johnny@navtek.no wrote:
> State: active

> Number Major Minor RaidDevice State
> 0 3  2 0 active sync /dev/hda2
> 1 22 2 1 active sync /dev/hdc2
> 2 0  0 2 faulty removed
> 3 34 1 3 active sync /dev/hdg1

active and degraded is a bad combination.  There is a small
possibility of undetectable data corruption.
I wonder why the system froze - that would contribute to the 'active'.

Add a '--force' to the '--assemble' and it will start the array for
you.

NeilBrown
