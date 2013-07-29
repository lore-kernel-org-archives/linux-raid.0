From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Suspicious test failure - mdmon misses recovery events on loop
 devices
Date: Mon, 29 Jul 2013 22:42:25 +0200
Message-ID: <51F6D3B1.1030800@arcor.de>
References: <51F2E2DD.8090204@arcor.de> <20130729165550.53c33bf3@notabene.brown> <51F6D30F.7060007@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F6D30F.7060007@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> My current idea to solve this is yet another separate thread just for
> monitoring kernel state changes. Don't have it ready yet, though.

Another idea would be in manage_member, after queueing the metadata
update and waking up the monitor, to wait for the metadata to finish
processing before actually starting the recovery (writing "recover" to
sync_action).

Martin
