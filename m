From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: RAID 5 questions
Date: Fri, 6 Aug 2004 00:49:43 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <ceukj7$s89$1@terminus.zytor.com>
References: <1091325475.2374.11.camel@localhost> <20040801102430.GC28625@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <20040801102430.GC28625@janus>
By author:    Frank van Maarseveen <frankvm@xs4all.nl>
In newsgroup: linux.dev.raid
>
> On Sun, Aug 01, 2004 at 11:27:56AM +0930, Ninti Systems wrote:
> > 
> > Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?
> 
> From software RAID it can't.
> 

Actually, it should be able to if the firmware can see all the drives,
AND you're not running it in degraded mode.  Obviously not a good
solution.  Use RAID-1 for /boot.

	-hpa

