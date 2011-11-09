From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: All kinds of things on RAID/mdadm
Date: Wed, 09 Nov 2011 10:50:40 -0800
Message-ID: <0luqo8x8bq.ln2@goaway.wombat.san-francisco.ca.us>
References: <4EB7D340.80009@mindconnect.nl>
 <4EB7D7A9.6080300@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-11-07, Miles Fidelman <mfidelman@meetinghouse.net> wrote:
>
> I'd like to echo this.  The unavailability of raid.wiki.kernel.org (as 
> well as the rest of *.wiki.kernel.org) is a rather critical outage.

As of this morning, raid.wiki.kernel.org seems to be back.

I've been looking it over, from the standpoint of a month-long user of
mdraid, and have found some minor points I'd like to change.  Is there
an accepted process for making modifications, or can anyone simply
create an account and update the wiki?  (In particular, the
Reconstruction page talks about powering down a system, but should also
mention hot-swap as an alternative; also, it mentions raidhotadd, which
IIRC is no longer part of the md tools; I believe mdadm /dev/mdX --add
/dev/sdXX is now the correct syntax?)

--keith



-- 
kkeller@wombat.san-francisco.ca.us


