From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: data loss+inode recovery using RAID6 write journal
Date: Tue, 25 Oct 2016 13:36:44 +0100
Message-ID: <580F51DC.3010308@youngman.org.uk>
References: <20161024235505.rb4fucq24ybbn5aq@schwarzgerat.orthanc>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161024235505.rb4fucq24ybbn5aq@schwarzgerat.orthanc>
Sender: linux-raid-owner@vger.kernel.org
To: Nick Black <dankamongmen@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/10/16 00:55, Nick Black wrote:
> I moved a ~20GB tarball from my home directory (located on another
> device, a NVMe md RAID1) to /media/trap/backups. The mv completed
> successfully. A short time after that, I hard rebooted the machine
> due to X lockup (I'm experimenting with compiz). By "short time", I
> mean "possibly within the time window before 20GB could be written
> out to the backing store, but I'm unsure about that". Upon restart,
> the machine engaged in minutes of disk activity, spat out some fsck
> inode recovery messages (I'm trying to find these in my logs), and
> finally mounted the filesystem. The moved file is nowhere to be
> found.

I can't see what filesystem you're using. It could easily be down to that.

If the reboot interrupted the "write to disk" before the directory
containing the i-node had been flushed, that would explain your
observations, I believe.

Personally, I think that explanation is actually unlikely, as the
kernel devs go to great lengths to preserve metadata, so you're more
likely to get the situation where the file exists but is empty.

This ties in with my impression of the kernel devs - especially the
file system guys - placing great emphasis on protecting the computer
at the expense of the data the user stores there. imho that's daft,
but hey they're system guys, they protect the system. "We can reboot
the system in a clean state in one hour instead of 24 now we no longer
need a fsck". They forget that that 24 hours gave the user a usable
system, now the admins need to run a 72-hour user-space integrity
check before they hand the system back ... :-(

I guess what I'm saying is, don't assume it's the raid, as it could
well be something else entirely (although there are probably plenty of
people here who could help you with that).

Cheers,
Wol
