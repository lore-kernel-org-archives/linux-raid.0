From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Tue, 19 Dec 2017 07:02:11 -0500
Message-ID: <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
 <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org>
 <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org>
 <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org>
 <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org>
 <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
 <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
 <CACsGCyS9-K4ZJPKauRZkGFRPd0cvShYLViE87i47=RCY1UkbnQ@mail.gmail.com>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/19/2017 05:35 AM, Alexander Shenkin wrote:

> Ok, so, it's now my understanding that I would normally be ok, having
> set the driver timeout to 180 secs (thus giving time for the seagate
> drive to report the read error back up to the MD layer before 180 secs
> is up).  In my case, however, the kernel hangcheck timer is interrupting
> the process (md?) that is waiting on the sector read at 120 secs.
> Therefore, the writeback doesn't happen.

Yes.  I think this behavior is a bug, and you need to work around it.

> Thus, I should set the hangcheck to something > 120 (say, 180 secs -
> should it be >180 to let the driver timeout first?).  Does this sound
> correct?  Apologies if I'm repeating info from before - just trying to
> be sure about what I'm doing before I go ahead and do it.
> 
> If that's correct, I'll add the following line in /etc/sysctl.conf:
> 
> kernel.hung_task_timeout_secs = 180

Yes.  For your kernel.

> I'll make sure the setting has taken, and then I'll run:
> 
> sudo /usr/share/mdadm/checkarray --idle --all

Makes sense.  Please report your results for posterity when the scrub is
done.

Phil
