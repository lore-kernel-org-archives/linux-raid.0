From: Stef Telford <stef@chronozon.artofdns.com>
Subject: RE: Software RAID level 1 issue
Date: 31 May 2003 13:44:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1054403067.14818.280.camel@testlin.hades>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com>
To: Brian Schwarz <Brian.Schwarz@veritas.com>
Cc: 'Greg Rasberry' <rgreg-r@pacbell.net>, 'Linux raid mailing list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brian Schwarz wrote:
<snip>

okay, sorry to start this email with a 'jab' or
tease, but really, this is a linux-raid development
mailing list, not a veritas placement plug list.

I think the MAIN thing that would cause a long resync
(on any raid volume) is more than likely one of the
disk drives or controllers is not setting the drive
into the proper udma setting and that, has little to
do with the RAID or LVM. suggesting 'veritas' as a
solution is NOT the 'correct' solution, as that would
be curing a symptom of the disease and not the actual
problem.

When i had one drive out of a 5 disk raid volume fail
to set to udma/133 and was stuck in udma/33, a typical
resync/rebuild of the 240gb raid would take the best
part of 2 days (scary but true). if in doubt, check
and then double check your dmesg output to find which
mode is being activated for each disk and if there is
any such lines as 'masking irq' (usually a controller
conflict)

so, if in doubt, check dmesg, check /proc/interrupts
for conflicts and no, during resync's on raid-1 the
mirror will not be available. for that, use a raid
level such as raid-5 or raid-10.

regards
Stef Telford <stef@chronozon.artofdns.com>

