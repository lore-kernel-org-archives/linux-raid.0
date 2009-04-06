From: Ferenc Wagner <wferi@niif.hu>
Subject: harmful parallel AoE check/resync
Date: Mon, 06 Apr 2009 16:31:11 +0200
Message-ID: <87ljqdvopc.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

md_do_sync() in md.c takes care not to resync/check MD devices built
on different parts of the same physical device in parallel.  This does
not account for AoE devices, which, however, most of the time share
and are limited by network bandwidth.  Thus a monthly data check
congests all AoE RAIDs at the same time.  Don't you think this case
should be handled specially, and such devices should be serialized by
default (possibly overridden by parallel_resync, of course)?  This
could be implemented in match_mddev_units by returning true for any
two AoE devices, for example.  Or leaving that alone, and extending
parallel_resync with a new option to force serialization.  Maybe this
would be more elegant.  What do you think?

(Please Cc me, I'm not subscribed.)
-- 
Thanks,
Feri.
