From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: RAID 5 from 2.4.24 to 2.6.0
Date: Thu, 8 Jan 2004 17:28:36 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040109012836.GT1882@matchmail.com>
References: <20040108151447.GA15294@piper.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040108151447.GA15294@piper.madduck.net>
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 08, 2004 at 04:14:47PM +0100, Martin F Krafft wrote:
> Due to stability problems with the RAID code in 2.4 (detaailed
> message forthcoming), I would like to try 2.6.0 on one of our
> servers. However, anticipating problems, I want to make sure that
> this change is not irreversible.
> 
> Can I mount RAID 1 and 5 partitions in 2.6.0 and 2.4.24
> interchangeably?

Yes, you can.

Though since the 2.4 raid code is quite fragile in states not possible from
2.4 code, I found one problem a while back where 2.6-test would set the state
bits wrong.  The problem was fixed though.

You can use 2.6 and 2.4 raid interchangably, but don't scrimp on persuing
the problem from a 2.4 perspective.
