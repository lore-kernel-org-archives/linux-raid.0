From: Michael Alan Dorman <mdorman@debian.org>
Subject: Can you non-destructively add a new active device to an existing RAID1?
Date: 18 Oct 2002 08:45:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87elanvru5.fsf@viola.mallet-assembly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

During a bit of an emergency a couple of weeks ago---my laptop quit
working unexpectedly---I found myself hurriedly building a new machine
from parts I had lying around, and although I only had one hard drive
on hand I decided to set things up so that I could pick up a second
hard drive and mirror my data.

Unfortunately, I appear to have done it incorrectly, in that I did not
specify that there should be two devices in the mirror with one of the
devices to be "missing", but instead specified one device in the
mirror.

Now, of course, I've had the time to pick up a second drive, and I'm
wondering if there is anything I can do to get this second drive in
active mirroring mode (as opposed to adding it as a hot spare) without
having to copy everything to the new drive, recreate the mirror
"correctly", copy everything back and then hot-add the drive?

I would just like to spare myself the downtime if at all possible.

Mike.
