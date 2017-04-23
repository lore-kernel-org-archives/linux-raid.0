From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 12:46:06 +0200
Message-ID: <20170423104606.GA4603@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 23, 2017 at 12:23:17PM +0200, Patrik Dahlström wrote:
> At this point, it is incorrect.

:-(

> I've lost the output from the working
> raid too, unless it's located in any log in /var/log/.

If you have kernel logs from before your accident...
check for stuff like this:

[    7.328420] md: md6 stopped.
[    7.329705] md/raid:md6: device sdb6 operational as raid disk 0
[    7.329705] md/raid:md6: device sdg6 operational as raid disk 6
[    7.329706] md/raid:md6: device sdh6 operational as raid disk 5
[    7.329706] md/raid:md6: device sdf6 operational as raid disk 4
[    7.329706] md/raid:md6: device sde6 operational as raid disk 3
[    7.329707] md/raid:md6: device sdd6 operational as raid disk 2
[    7.329707] md/raid:md6: device sdc6 operational as raid disk 1
[    7.329924] md/raid:md6: raid level 5 active with 7 out of 7 devices, algorithm 2
[    7.329936] md6: detected capacity change from 0 to 1500282617856

That's not everything but it's something.

Also in the future for experiments, go with overlays.

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
(and the overlay manipulation functions below that)

Lets you mess with mdadm --create stuff w/o actually overwriting original metadata.

Regards
Andreas Klauer
