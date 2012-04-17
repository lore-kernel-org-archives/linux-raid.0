From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?=
	<kristleifur@videntifier.com>
Subject: A RAID Story
Date: Tue, 17 Apr 2012 20:44:24 +0000
Message-ID: <CAP_afxf+VXf3XCZi6mTS+2Yv3j2=_OwrYpFV_uTzZU0G7fjE0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I want to put some information out there. Forgive me for the long
email. At my company, we have very successfully been using mdadm for a
few largish arrays, using RAID0 on top of RAID6 sets. One of these
arrays-of-arrays is inventively named /dev/md/tank and has been
running happily since 2009-2010 or so. This a volume of 20 consumer
drives, each 1.5TB, total ~21.5TB. It consists of two RAID6 arrays,
each with 10 drives. These are striped together to create the final
volume. Speed is good, CPU load is low, all is well. We have done two
successful drive swaps. Routine stuff. Works swimmingly.

Then we were doing the third drive swap the other day. We figured out
which drive was the bad one, pulled it, put a new one in and went to
add it to the array. We were using Palimpsest (a.k.a.
gnome-disk-utility) to check SMART status etc. Palimpsest is great.
Therefore we decided to use Palimpsest to add the replacement drive to
the RAID6 subarray - /dev/md/d1_tank ("device 1" in the large stripe
set). Palimpsest has a nice button to do this and a convenient list of
available devices. We take a deep breath and move to click the button.
And ...

For some weird spastic reason, when working in the device selection
window, we somehow manage to select *the d1_tank array itself* as the
device to be added to d1_tank. I don't even know how it happened. I
believe we simply failed to take the correct precautions of being
perfectly rested and calm during the operation. So what happened is
that Palimpsest happily added d1_tank as a member of d1_tank.

Didn't think that could happen.

For some mysterious and fortunate reason, the device-added-to-itself
didn't become an active device in itself, only a spare. In theory we
had written nothing to it except the new metadata. We proceeded to
take a week to think, wake up in terror at night, pace anxiously
around, and learn the mdadm manpage by heart. We had a good look at
the intact metadata from device 0 of the stripe set, found the chunk
size, metadata type etc., and and built a new mdadm --create command
to create an array that would be exactly the same size and shape as
the old stripe set, and included --assume-clean for good measure. In
theory this would just put some new metadata in place on the RAID6
arrays and get an identical array going with the JFS filesystem data
intact. We ran the create command. Deep breath. Read-only fsck on
device ...

"The superblock does not describe a correct jfs file system."

Despair!

We checked the new mdadm --examine output against the old - and the
data offset was 2048 sectors in the new stripe set, but had been 8
sectors in the old stripe set. Couldn't find any option to change the
data offset manually. After searching through pretty much the entire
Internet, we saw that as of mdadm 3.1.2 released March 10 2010, the
data offset is calculated such that data starts on 1MB boundaries.
Looking at the old metadata readout, we see that the stripe set was
originally created in January 2010, and therefore with an older
version. OK! We downloaded and compiled mdadm-3.1.1, ran the same
--create command using that binary ... fsck again ... Filesystem OK!

Close call, huh?

Thank you for mdadm.
