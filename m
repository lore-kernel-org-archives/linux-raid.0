From: Alex Butcher <linraid@assursys.co.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 08:13:08 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
References: <h8nbt5$n8p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h8nbt5$n8p$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Sep 2009, Matthias Urlichs wrote:

> my problem is that I have a bunch of crappy disks which seem unable to
> reliably remap bad areas after a read error.

IME, discs don't remap after read errors, only on writes.

> This obviously makes the read error rewrite feature of our beloved
> RAID5/6 code somewhat less than useful.

Are you sure that refresh-writes triggered by read errors are expected
behaviour of md's RAID5/6 mode? Only they weren't for RAID1 until somewhat
recently (2.6.15, IIRC).

Best Regards,
Alex
