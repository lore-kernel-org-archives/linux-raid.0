From: Neil Brown <neilb@suse.de>
Subject: Re: Partitions with == or \approx same size ?
Date: Sat, 21 Jul 2007 07:48:56 +1000
Message-ID: <18081.11720.547650.571674@notabene.brown>
References: <Pine.LNX.4.58.0707201908020.30683@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Seb on Friday July 20
Sender: linux-raid-owner@vger.kernel.org
To: Seb <seb@h-k.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 20, seb@h-k.fr wrote:
> 
> Could you tell me if such a mechanism exists in mdadm?
> Or should I accept the "loss" of the 150 GB?

When you give mdadm a collection of drives to turn into a RAID array,
use bases the size of the array on the smallest device.

You might want to make it a little smaller still in case you have to
replace a device with a slightly smaller device (it happens).  You can
use "--size" to reduce the used space a little further if you like.

NeilBrown
