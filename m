From: linux@horizon.com
Subject: Re: Minor RAID-1 oddity... any way to fix?
Date: 4 Sep 2003 21:19:33 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030904211933.20426.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This is normal. md puts spare drives in higher slots initially. When the
> recovery is done, you'll see the drive move back to its usual slot 0.

Indeed, reconstruction just finished and I noticed that!

Sorry to waste people's time...
