From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Doing 'echo repair > /sys/devices/virtual/block/md?/md/sync_action'
 does not result in mismatch_cnt of 0 on RAID-6?
Date: Fri, 01 Apr 2011 23:44:37 +0100
Message-ID: <4D965555.10504@tuxes.nl>
References: <4D7F4DF3.7010804@tuxes.nl> <20110315121351.GA7190@cthulhu.home.robinhill.me.uk> <4D7F6CE5.4010303@tuxes.nl> <20110315141342.GB7190@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315141342.GB7190@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/15/2011 02:13 PM, Robin Hill wrote:
> On Tue Mar 15, 2011 at 01:43:01PM +0000, Bas van Schaik wrote
>> My other question is still standing:
>>> Furthermore, theoretically it should be possible to indicate which
>>> device in the RAID-6 array contains the inconsistent data, or am I
>>> mistaking? If so, that would certainly be a nice feature to see
>>> implemented, as it would help diagnosing problems.
>> Am I indeed correct in thinking this?
> I'm not sure. If it's a single data block that's failed then you should
> be able to, for each disk, re-generate the data using the other disks
> and the P parity, then validate against the Q parity (if it matches then
> that disk is the incorrect one). You should also be able to detect
> errors in either the P or Q parity (if one is valid for the data and the
> other isn't).  If there's multiple disks which are incorrect then I
> don't think there's any way you can tell which (or even avoid having one
> of the correct disks flagged as incorrect).
Indeed, that is what I was thinking. As I've just discovered some new
block mismatches (that's 2 weeks after the last repair!) on my 8x2TB
RAID6 array, it would be really nice to see this feature implemented...
I would be happy to contribute, but I am not very experienced in hacking
kernel C.

Any tips, tricks and/or suggestions anyone?

Cheers,

  Bas
