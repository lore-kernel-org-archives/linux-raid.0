From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm-grow-continue service crashing (similiar to "raid5 reshape
 is stuck" thread from May)
Date: Mon, 13 Jul 2015 19:37:32 +0100
Message-ID: <55A4056C.6050004@youngman.org.uk>
References: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>	<55A26F65.5020703@turmel.org> <CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/07/15 20:24, Edward Kuns wrote:
>> > many modern distros delete /tmp on reboot and/or play
>> > games with namespaces to isolate different users' /tmp spaces.

> So if the machine crashes during a rebuild, you may lose that backup
> file, depending on the distro.  OK. 

Please note that this is the DEFINED behaviour of /tmp, so it has a very
high probability of happening.

If you want temporary data to survive a reboot, put it in /var/tmp.

Oh - and if SeLinux only lets you put it in /tmp, what happens if you
don't have a separate /tmp partition? You can't put the  backup file on
the partition you are rebuilding, and SeLinux won't let you put it
anywhere else? That's a big disaster in the making ...

Cheers,
Wol
