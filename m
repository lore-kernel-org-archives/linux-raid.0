From: Phil Turmel <philip@turmel.org>
Subject: Re: Help needed: array inactive after grow attempt
Date: Tue, 3 May 2016 14:47:23 -0400
Message-ID: <5728F23B.9070700@turmel.org>
References: <1d5a8c36a6802a9e7e32eb056165f200@spoilbase.eu>
 <7cfbdd22b8c20acdb95fababfa1a04a6@spoilbase.eu>
 <e7110adb04c7319afd4ae4ee856e4bec@spoilbase.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e7110adb04c7319afd4ae4ee856e4bec@spoilbase.eu>
Sender: linux-raid-owner@vger.kernel.org
To: Andread Mayrhoff <repro@spoilbase.eu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/28/2016 04:02 PM, Andread Mayrhoff wrote:
> Some more info:

I noticed this hasn't been answered in several days.  Not sure if you
are still in trouble.

Anyways, since you are using metadata version 1.0, mdadm cannot use
starting position manipulations to avoid the need for a backup file.

Your mdadm -E reports all show the reshape position == 0, meaning it
didn't actually reshape anything.

You should try assembling with a --backup-file option and possibly also
the --invalid-backup option to see what happens.  Include --verbose and
show the output here if it still doesn't work.

Phil

