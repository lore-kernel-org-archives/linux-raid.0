From: Phil Turmel <philip@turmel.org>
Subject: Re: Repairing R1: Part tabl, & precise command
Date: Tue, 5 Apr 2016 11:28:15 -0400
Message-ID: <5703D98F.4020503@turmel.org>
References: <57038211.6040101@tesco.net> <57039BCC.6040103@tesco.net>
 <5703AE18.700@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5703AE18.700@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/05/2016 08:22 AM, Ron Leach wrote:
> 
> mdadm  -- manage  ..  --add  ..
> 
> commands and whether mdadm needs to be inhibited from taking any
> automatic remedial action.

If your array has write-intent bitmaps, use --re-add instead of --add.
It'll be quick.  Otherwise just --add and let it rebuild.

Phil

