From: Neil Brown <neilb@suse.de>
Subject: Re: Events?
Date: Sun, 31 May 2009 07:46:32 +1000
Message-ID: <18977.43320.811246.171065@notabene.brown>
References: <20090530194545885.SLWT5991@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Leslie Rhorer on Saturday May 30
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 30, lrhorer@satx.rr.com wrote:
> 
> What does the "Events" field reported by -Dt signify, and why does the
> number sometimes decrease?  I've seen the number change, but I don't see
> anything in any of the system logs corresponding to something that would
> seem to relate.

Changes just as device failure and adding or removing a device.
Also transitions from 'active' to 'clean' and back.
Sometimes the dirty->transition causes the event counter to retreat if
md is use the new 'clean' state is indistinguishable from the old
'clean' state.  This allows us not to always be waking up spare drives
just to tell them about clean->active->clean transitions.

NeilBrown
