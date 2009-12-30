From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 1 Disk added as faulty
Date: Wed, 30 Dec 2009 19:52:46 +1100
Message-ID: <20091230195246.46b02a03@notabene.brown>
References: <6E.31.08392.1B5FA3B4@cdptpa-omtalb.mail.rr.com>
	<C3.9D.08510.FCEFA3B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C3.9D.08510.FCEFA3B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 30 Dec 2009 01:18:32 -0600
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 	Oops!  'Sorry, I was on  the wrong server.  The server with the PATA
> drives also allowed me to add with a -W switch this time, but the logs on it
> show even less:

:-)

Can you do:

mdadm /dev/md1 -f /dev/hda1
mdadm /dev/md1 -r /dev/hda1
mdadm -D /dev/md1
mdadm -E /dev/hda1
mdadm /dev/md1 -a -W /dev/hda1
mdadm -D /dev/md1
mdadm -E /dev/hda1

and show me all the output along with kernel log messages
generated at the time.

NeilBrown
