From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: detection/correction of corruption with raid6
Date: Wed, 17 Dec 2008 22:52:51 +0100
Message-ID: <1229550771.13544.20.camel@localhost.localdomain>
References: <1229464713.6159.16.camel@localhost.localdomain>
	 <1229466317.22331.71.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1229466317.22331.71.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2008-12-16 at 23:25 +0100, Redeeman wrote:
[...]
> > Why a RAID system might have inconsistencies?
> > Why do we have a "check" command at all, to run weekly or monthly?
> As previously stated in discussion, while most bitflips etc does not
> happen on disk(apparently), they do happen, whether its in ram, pci,
> controller etc...

Ah! You spoiled it! :-)

Actually I was waiting for an answer from Neil Brown.

Because I'm under the impression that if it is not the HD,
it does not count... See below...

> Also, i imagine its just to be on top of things, read and ensure stuff
> works.. (but this is pure speculation)

I still have some comments on the topic.

First of all, someone mentioned the CRC/EDAC capabilities in the
filesystem. While this would be advisable, there is a fundamental
problem with it: there is no information on which device could
have caused the error (in case of RAID).
The FS can report, maybe correct, the data, but it is unaware of
the underlining hardware, so it does not help further.
On the other end (not hand), there are the device drivers.
Also these may report errors, but it can also be they just
deliver garbage, for several reasons.
The only component which can handle the problem is the "md", since
this is the only one which knows the devices _and_ the data.

Second. As mentioned above, it seems to me that RAID scope is
intentionally limited to pure HD failures.
Nowadays, one could build a RAID over usb-storage plus fw-sbp2
plus nbd plus esata.
The "HD" is not anymore the physical thing, it is everything
from the specific driver on.
If I stomp on the USB cable, detaching it, I would like the RAID
reacting as a real HD failure occurred (actually it does it properly).

So, IMHO, the argument that the "soft errors are improbable
within the HD" is limited, since it can happen elsewhere and
it should count like it was in the HD, IMHO...


Final point. More or less one year ago the same topic popped up,
with similar discussion.
At the end of the thread someone was asking if patches are
accepted in order to implement this feature.
I could not find any answer to that question in the archive.

What is the idea? Are patches accepted? Rejected by default?

Not that I want to provide one, but I was just curious...

bye,

-- 

pg








