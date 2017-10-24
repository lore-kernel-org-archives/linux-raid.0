From: Roman Mamedov <rm@romanrm.net>
Subject: Re: upgrading LSI SAS9211-8i fw IR->IT
Date: Tue, 24 Oct 2017 17:14:57 +0500
Message-ID: <20171024171457.563fbb2a@natsu>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 24 Oct 2017 22:47:48 +1100
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> I now want to upgrade the fw from IR to IT.

Is there any practical reason for doing that?

I have a SAS9212-4i with a very ancient IR firmware -- and the thing is, it
just works perfectly as a dumb SATA controller, including full SMART access to
connected disks -- what else is there to ask from it?

(no TRIM pass-through, but that's kind of "by design" with these cards, and I
doubt it's fixed in the new firmware)

If I'm not mistaken it's IT that is the simpler firmware for when you don't
need the hardware RAID, but considering the above, and how cumbersome and risky
the flashing process is, what am I losing by staying with IR?

Anyways here's one more HOWTO on flashing that may or may not be more helpful
than the ones you listed:
https://wiki.hackspherelabs.com/index.php?title=LSI_Raid_Firmware_Bios_Flashing

-- 
With respect,
Roman
