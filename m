From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: RAID6 fails to assemble after unclean shutdown
Date: Wed, 25 Apr 2012 20:50:06 -0700
Message-ID: <e8tm69x5k8.ln2@goaway.wombat.san-francisco.ca.us>
References: <20120425103536.GA9978@nsrc.org>
 <20120425210145.73b1e51b@notabene.brown> <20120425111606.GA10101@nsrc.org>
 <4F98B9EF.40207@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-04-26, Bill Davidsen <davidsen@tmr.com> wrote:
>
> Without a bitmap you can spend days getting back up instead of minutes. Brian 
> has the true truth here, unless there is a reason to avoid it, a bitmap is a 
> ticket to a sane rebuild.

My impression was that a bitmap only helped on an unclean shutdown or on
re-adding a disk that was previously removed, and not on failing a drive
and adding a new one.  Is that accurate?  (Of course it would help the
OP if he has another unclean shutdown.)

As Neil posted last month, you can't use mdadm 3.2.3 to create the
bitmap; use 3.2.2 or check out from git.  (I just ran into the bug in
3.2.3 and found the message in the archive.)

--keith


-- 
kkeller@wombat.san-francisco.ca.us


