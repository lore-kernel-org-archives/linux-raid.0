From: "NeilBrown" <neilb@suse.de>
Subject: Re: Help
Date: Tue, 25 Aug 2009 09:38:41 +1000 (EST)
Message-ID: <1ed3b9f9d3d17505f68e7a882aef5f7c.squirrel@neil.brown.name>
References: <200908210627.06241.Info@quantum-sci.net>
    <B0F2EBD236974CA9878F0752EACFC835@m5>
    <200908230631.46865.Info@quantum-sci.net>
    <200908241608.19739.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908241608.19739.Info@quantum-sci.net>
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, August 25, 2009 9:08 am, Info@quantum-sci.net wrote:
>
> The sync has finally finished, but something's wrong with the first
> partition set;  Only sda1 is a member of md0.  In dmesg I find:
> [    4.756365] md: kicking non-fresh sdb1 from array!
>
> Huh?  If it's not fresh, why doesn't it sync it?  What should I do about
> this?  How did it happen on a new array?


You'll need to provide a lot more information, starting with
kernel log at all relevant times (and don't use 'grep', just cut out
of contiguous section of the log including a few lines before and
after anything that might be relevant).
And "mdadm -E" of any relevant device.

"Kicking non-free sdb1 from arrays" is a message that you get when
assembling an array if the metadata on sdb1 is older than the others.
This can happen if it was evicted from the array due to failure or
if the array was assembled without sdb1 for some reason.  There
are probably other scenarios.
That is why I need to see recent history, including anything
from the last time the array was active.

NeilBrown


