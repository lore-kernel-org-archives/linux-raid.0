From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Wed, 20 Jul 2016 17:10:31 +0100
Message-ID: <578FA277.7030001@youngman.org.uk>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
 <578E8616.4000908@youngman.org.uk>
 <CADsVfeyz=KiAqSBe11jjBT-yOWpZp_eyP_BctkjvWC5UPNLXuQ@mail.gmail.com>
 <578F8B2D.5070003@youngman.org.uk> <20160720200726.2e399266@natsu>
 <578F9A6F.3050503@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <578F9A6F.3050503@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Amit Biswas <abiswas@nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/07/16 16:36, Wols Lists wrote:
> Get that first 3TB drive. NOW. Physically replace sda in the machine,
> and configure it as a single-drive mirror ( --create --devices=2 sda
> spare).

Just noticed your edu address. If Phil Turmel chimes in, he'll tell me
off for telling you to spend money :-)

If you are an impecunious student, and your data will fit on 2TB, then
beg borrow or steal :-) a 2TB drive.

Use that as your backup, mirrored, as I said, and then you can combine
the two constellations into a 2TB raid0, and add that in as the second
half of your mirror. That will at least give you a working, safe, raid
system.

Cheers,
Wol
