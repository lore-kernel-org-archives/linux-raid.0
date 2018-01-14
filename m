From: Michael Fritscher <michael@fritscher.net>
Subject: Re: How can I reassemble a raid1 on a intel fake raid? - solved
Date: Sun, 14 Jan 2018 12:23:23 +0100
Message-ID: <b14ca4f0-8103-c0a6-0e02-53c6485412ae@fritscher.net>
References: <7ea51b30569c6336c261b295bb729ce1.squirrel@mifritscher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7ea51b30569c6336c261b295bb729ce1.squirrel@mifritscher.de>
Content-Language: de-LU
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

the solution was to restart the server (the HDD was hot-swaped). Then in
the Raid-BIOS I was asked whether I want to rebuild, which I acked.
After this, linux began to rebuild it. So initiating the rebuild seems
to be brocken, but not the rebuild process itself.

Best regards,
Michael Fritscher
