From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: aoe freezes 2.6.26.6
Date: Tue, 21 Oct 2008 19:21:03 +0200
Message-ID: <87ljwhn9ts.fsf@tac.ki.iif.hu>
References: <871vyb9on9.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871vyb9on9.fsf@tac.ki.iif.hu> (Ferenc Wagner's message of "Mon,
	20 Oct 2008 19:12:26 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ferenc Wagner <wferi@niif.hu> writes:

> I've got a total of 55 AoE devices.  Some of them come from Coraid
> EtherDrive 1521 boxes (e1[0-3].*) and some are VS21 logical units
> (e10[01].*).  This works with 2.6.18 and its stock AoE driver (v22).
> But if I load the aoe module under 2.6.26.6, it freezes my system like
> this: [...]

Forgot to say: it freezes under 2.6.27 as well (which has the same v47
AoE driver as 2.6.26).  And there are 21 (that is more than 16)
"slots" exported by the VS21 unit on "shelf" 100.  If those devices
simply didn't show up, I wouldn't complain, but freezing the kernel is
a show-stopper for me.  I uploaded the full console log of a boot
attempt (ripe with sysrq interaction) with 2.6.27 to
http://rs22.lvs.iif.hu/aoe_freeze.log
-- 
Regards,
Feri.
