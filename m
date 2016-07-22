From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Fri, 22 Jul 2016 09:56:14 -0400
Message-ID: <b14ee34f-8831-89fd-b732-9b6a787bc379@turmel.org>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
 <578E8616.4000908@youngman.org.uk>
 <CADsVfeyz=KiAqSBe11jjBT-yOWpZp_eyP_BctkjvWC5UPNLXuQ@mail.gmail.com>
 <578F8B2D.5070003@youngman.org.uk> <20160720200726.2e399266@natsu>
 <578F9A6F.3050503@youngman.org.uk> <578FA277.7030001@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <578FA277.7030001@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: Amit Biswas <abiswas@nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2016 12:10 PM, Wols Lists wrote:
> On 20/07/16 16:36, Wols Lists wrote:
>> Get that first 3TB drive. NOW. Physically replace sda in the machine,
>> and configure it as a single-drive mirror ( --create --devices=2 sda
>> spare).
> 
> Just noticed your edu address. If Phil Turmel chimes in, he'll tell me
> off for telling you to spend money :-)

No, not this time.  :-)

I would also note that the raid1 composed of the six sd?2 partitions is
only operating as a two-copy mirror -- the other four devices are
spares.  Whoever created that array added the extra drives but never
used --grow to set the number of mirrors to six.

Amit, as soon as you get your arrays assembled with the --force option,
follow Wol's advice on rsync'ing to a new array.  I wouldn't advise
trying to fix the UREs on your existing arrays since there are so many
that you'd certainly trip the 10/hr read error limit in MD.

Just copying data may also trip the read error rate limit, but you have
no choice.  If it happens and kicks out any array devices, simply stop
the rsync, stop and re-assemble the array (with --force), and continue
with rsync.

The Constellations can probably be recycled into spares or backup
devices after you copy your data.  I didn't look close at their stats.

Phil
