From: "Ryan, MichaelS (ENG Redmond)" <michaels.ryan@emc.com>
Subject: raid repair checkpoint enhancement
Date: Thu, 4 Oct 2012 13:26:35 -0400
Message-ID: <A389B1DB577EF14DAA0CB1D40CF2EF5F016DF575A6@MX45A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi all.

If a device reboots during a raid repair operation ("echo repair > /sys/block/md0/md/sync_action"), the raid repair is interrupted and not restarted. For devices that are shutdown nightly, this could prevent a raid repair from ever getting to the far reaches of the array.  I'd like to see an enhancement that would checkpoint the raid repair operation on shutdown similar to how a sync operation is checkpointed.  Preferably, the raid repair would be restarted automatically on the next boot at the checkpoint location.  Alternatively it could require user input to restart the operation at either the checkpoint location, or at the beginning.

Any thoughts on this enhancement?
Thanks
- Michael
