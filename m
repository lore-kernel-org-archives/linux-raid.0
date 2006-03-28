From: Rob Harris <rharris@shabadoo.org>
Subject: no-reboot mirror creation
Date: Tue, 28 Mar 2006 09:08:28 -0500
Message-ID: <4429435C.6070704@shabadoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK. Stupid question.

So, I have a 300G drive in my system, 'bout half full running jfs.

I added a second 300G drive because I want to do mirroring.

I don't have place to copy the data off to create a clean two-drive 
mirror from the get go, so I:

- created a one-drive mirror using mdadm (requiring --force) on the new disk
- mounted it
- copied the data over from the non-raid disk to the raid disk
- verified that all the data was copied
- changed the type of the partition on the old disk to FD
- # mdadm /dev/md1 --add /dev/hdf1 (added the newly created partition)

It seemed to work... kinda. It didn't actually add the partition to the 
mirror, but just set it as a spare; i.e. I never see it syncing the data 
from the old disk to the new.

Is there a way that I can add the drive to the mirror without setting it 
as a spare?

Thanks.
-R

