From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: mdadm: superblock on /dev/sdr1 doesn't match others - assembly aborted
Date: Fri, 27 Jan 2006 11:53:12 +0100
Message-ID: <pan.2006.01.27.10.53.10.967727@smurf.noris.de>
References: <1138145033.43d6b70968906@mail.lr-netcon.de> <17366.54032.174297.848326@cse.unsw.edu.au> <1138224502.43d7ed76d888a@mail.lr-netcon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, mdadm wrote:

> ATM I am still not sure about what caused the crash, maybe you are right
> and there is a hw problem. I assume it is the  memory.

Personally I would, if I saw such an error, immediately stop the system,
run memtest86+ on it, and either replace the faulty RAM or, if no problem
is found, do the reconstruction on a different mainboard.

Bit errors scare me. The idea that the problem will propagate to some
unknown area of a presumed-good array scares me even more. (I speak from
painful experience here.)

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
The price of seeking to force our beliefs on others is that someday
they might force their beliefs on us.
		-- Mario Cuomo


