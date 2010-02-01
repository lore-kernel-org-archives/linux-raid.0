From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: RE: Why does one get mismatches?
Date: Mon, 1 Feb 2010 23:14:37 +0000
Message-ID: <556744.39303.qm@smtp101-mob.biz.mail.ac4.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: 
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But what if 2 of the three sources say xyz then you can make a guess that has a higher propencity to beng right? I guess this would also work for raid 6.

Incidently the problem of my mismatches was almost certainly badly seated ram... But my tests are ongoing to be sure....



-----Original Message-----
From: Neil Brown <neilb@suse.de>
Sent: 01 February 2010 22:37
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jon@eHardcastle.com; linux-raid@vger.kernel.org
Subject: Re: Why does one get mismatches?

On Mon, 01 Feb 2010 16:18:23 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> Comment: when there is a three way RAID-1, why doesn't repair *vote* on 
> the correct value instead of just making a guess?
> 

Because truth is not democratic.

(and I defy you to define "correct" in any general way in this context).

NeilBrown

