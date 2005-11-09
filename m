From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: intent-logging, not synchronizing written blocks?
Date: Wed, 9 Nov 2005 20:27:49 -0200
Message-ID: <17266.30693.504831.133082@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Is intent-logging for raid5 already in mainline or only in -mm? I
looked for it in 2.6.14 and found nothing...

It seems that intent-logging accelerates synchronization by skipping
the blocks that have not changed since the array went out of sync. I'm
not sure but if this is correct I thought that another way to speed
re-sync would be to not sync the blocks that were written to the array
after it started, since they should be already up to date. Is there a
way to do this? Does intent-logging takes this into account?
