From: Michael Tokarev <mjt@tls.msk.ru>
Subject: usefulness of drive "failed" state
Date: Tue, 20 Nov 2012 13:39:18 +0400
Message-ID: <50AB4FC6.1080808@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello.

When a drive fails for some reason, it remains in the
array with "Failed" state, untill it is removed.

The question is: how useful this state is?  What it is
used for, or can be used for, in practice?

In particular, there apparently no way to re-add the
drive which is in failed state without removing it first.
Also, there's no way to "clear" the "faulty" state.

Can't the failed drive be just removed from the array,
instead of being kept there?

Thanks,

/mjt
