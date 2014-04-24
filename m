From: Jeff Wiegley <jeffw@csun.edu>
Subject: Repaired the sectors of a drive, how do I get the md to assemble
 and start degraded?
Date: Thu, 24 Apr 2014 08:05:27 -0700
Message-ID: <53592837.8020406@csun.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a storage box that I'm attempting to get data off of.

The box was pulled by another because mdadm shut the md device
off due to hard drive errors. and because the OS harddive (separate)
had a motor failure. I replace the OS drive and install a fresh
copy of Ubuntu server 14.04.

When I brought the machine up I thought we were in luck because
it auto assembled and started the Raid 6 array were all the data is.
But it showed that 2 of the 15 drives were off line... [UUUUUU_UUUUU_UU]
something like that. So I mounted the fs and began a tar backup to
another storage location overnight.

During the night it failed a third drive (which is probably what
brought it down in the first place.) I have been able to repair the
drive with Seagate's SeaTools. Now I want to plug the drive back in
and bring the array up in the 2-drive degraded state.

How do I do this? how do I specify a command to take these 15 drives,
mark two of them failed and force the assembly and start of the
remaining 13 good drives (though one has probably been marked as failed
in the past?)

- Jeff

