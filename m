From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Timeout question
Date: Mon, 04 Nov 2013 15:29:31 -0800
Message-ID: <r7nlkaxkh8.ln2@goaway.wombat.san-francisco.ca.us>
References: <5277FE65.8050001@hanswkraus.com> <5278220C.3060607@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-11-04, Phil Turmel <philip@turmel.org> wrote:
>
> Make sure you also have a "check" scrub in a cron job for everything
> greater than raid0.  (Interval can vary--I use weekly.)  And follow up
> on the cron job with a report of all mismatch-cnt values.

RHEL/CentOS already has a script which does this; IIRC it emails root if
mismatch_cnt is nonzero after the check is complete.

> For large capacities with consumer drives (~8TB or more, IMHO), you
> should seriously consider raid6.

I'm assuming you mean arrays larger than 8TB, not individual drives!  :)
I have had a second drive fail in a large array after the first one
failed and a rebuild started, so this isn't just a theoretical
discussion.

--keith


--  
kkeller@wombat.san-francisco.ca.us


