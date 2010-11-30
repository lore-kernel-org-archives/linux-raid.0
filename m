From: Walter Haidinger <walter.haidinger@k9-shop.com>
Subject: rewrite for sync_action for drive refresh
Date: Tue, 30 Nov 2010 16:26:20 +0100
Message-ID: <4CF5179C.9010205@k9-shop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

How about a "rewrite" target for sync_action to force a
rewrite of all data, i.e. a "repair+always write" mode?

Right now a forced rewrite can only be achieved by putting the
array in degraded mode and re-add the to-be-refreshed drive,
right?

Walter

