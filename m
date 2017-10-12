From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Thu, 12 Oct 2017 10:16:04 -0500
Message-ID: <CACsGCyQGZxhfT1A_ojXaBRvB4wgNOH7fqqh8afsQksAeGdKmjg@mail.gmail.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de> <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
 <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org> <8cb4bb54-fadc-30c3-58b9-16e1ca460e83@thelounge.net>
 <a7a4d586-5641-80e4-06e1-5dc1b772182b@shenkin.org> <8da0ac59-d83b-671c-b088-8e04b13d685e@turmel.org>
 <afaa1020-652d-911c-16e0-12ed87f2197a@shenkin.org> <7b011b63-4de6-44ec-1f74-9f33c6466795@turmel.org>
 <2ab868eb-3ce3-f01b-ac9e-23358563040c@shenkin.org> <59DF4B80.5010807@youngman.org.uk>
 <ecbbf0ae-3bf8-fe66-79e1-e8207bc09dcc@turmel.org> <5b28b0fc-5e4d-9ac3-9a82-7e36f25c5108@shenkin.org>
 <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ecT1Psph5Wm9LrPgYOba6PHKzAs55H1LWiqLD+kaBUQZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All y'all referring to a whole separate kernel module,
hangcheck-timer.ko?  If so, it appears that you can set the timeouts
(there is more than one) via kernel parameters.  I found this, which
has a long comment at the top explaining what it does:

https://github.com/spotify/linux/blob/master/drivers/char/hangcheck-timer.c

Here's the comment (reformatted):

The hangcheck-timer driver uses the TSC to catch delays that jiffies
does not notice. A timer is set. When the timer fires, it checks
whether it was delayed and if that delay exceeds a given margin of
error. The hangcheck_tick module parameter takes the timer duration in
seconds. The hangcheck_margin parameter defines the margin of error,
in seconds. The defaults are 60 seconds for the timer and 180 seconds
for the margin of error. IOW, a timer is set for 60 seconds. When the
timer fires, the callback checks the actual duration that the timer
waited. If the duration exceeds the alloted time and margin (here 60 +
180, or 240 seconds), the machine is restarted. A healthy machine will
have the duration match the expected timeout very closely.

There are four parameters to this kernel module:

MODULE_PARM_DESC(hangcheck_tick, "Timer delay.");
MODULE_PARM_DESC(hangcheck_margin, "If the hangcheck timer has been
delayed more than hangcheck_margin seconds, the driver will fire.");
MODULE_PARM_DESC(hangcheck_reboot, "If nonzero, the machine will
reboot when the timer margin is exceeded.");
MODULE_PARM_DESC(hangcheck_dump_tasks, "If nonzero, the machine will
dump the system task state when the timer margin is exceeded.");

The first two are times measured in seconds.  hangcheck_tick defaults
to 180 seconds and hangcheck_margin defaults to 60 seconds, at least
in the Spotify kernel version I found on github.

              Eddie
