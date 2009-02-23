From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Reliability of bitmapped resync
Date: Mon, 23 Feb 2009 22:36:46 +0100
Message-ID: <20090223213646.GA18555@lazy.lzy>
References: <20090223194019.GA3488@lazy.lzy> <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name> <49A3128F.9020708@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49A3128F.9020708@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Did you mean
> 	echo repair > /sys/block/md0/md/sync_action
>
> I run 'check' regularly and I am rather sure that it reports but does not fix the mismatches.

the sequence is as follow:

1) disk removed.
2) disk re-added
3) _automatic_ resync
4) manual check (after the resync finished)

The last check returns mismatches.

bye,

-- 

piergiorgio
