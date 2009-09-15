From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 07:29:18 +0000 (UTC)
Message-ID: <h8nfoe$n8p$3@ger.gmane.org>
References: <h8nbt5$n8p$1@ger.gmane.org>
	<alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Sep 2009 08:13:08 +0100, Alex Butcher wrote:

> IME, discs don't remap after read errors, only on writes.

Some may remap after recoverable read errors. However, the RAID code
does (I assume - see below) rewrite the data -- which the disk happily 
acknowledges  -- only to report the very same error next time that spot's 
being read. :-(

> Are you sure that refresh-writes triggered by read errors are expected
> behaviour of md's RAID5/6 mode?

Not 100%, no -- but recovering the data but otherwise ignoring the error 
(other than increment the error counter) would be a level of foolishness 
I won't assume of the RAID code's authors.

-- 
Matthias Urlichs

