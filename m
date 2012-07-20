From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Fri, 20 Jul 2012 16:44:22 -0400 (EDT)
Message-ID: <2a2061ca-29d1-4397-9eed-a4f4941090a4@zmail15.collab.prod.int.phx2.redhat.com>
References: <CABYL=Tp+ACU2qhfoa_-_VHU3siMNQjf+c1CfJ3=KFLFvPsmVuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=Tp+ACU2qhfoa_-_VHU3siMNQjf+c1CfJ3=KFLFvPsmVuA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: stan@hardwarefreak.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> yeah for a 'fast' solution moving from one file system to another
> that
> works with theses checks can help you, while we check if this is
> usefull or not
> 
> IMHO, if we implement this, we should implement outside any today
> raid
> levels, this should be done between device and filesystem, in others
> words:
> 
> we should implement this to work like:
> DISKS - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1 PER DEVICE) -
> TODAY RAID LEVELS - FILESYSTEMS
> 
> or
> 
> DISKS - RAIDS LEVELS - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1
> PER DEVICE) - FILESYSTEM
> 
> or
> 
> DISK - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1 PER DEVICE) -
> FILESYSTEM
> 
> 
> using this, we "could give more security" to usb pendrives for
> example, and any block device (network block device, DRBD, or
> anyother
> block device in linux)

Well ... it looks more modular, easier and could have more usecases.
You're probably right at this point. Dracut maintainers would kill
us both, but that's a different story.
I'm only missing that possibility of immediate resyncing of the data
when a corruption is detected. That's probably the only thing, that
would be nice to have directly in the RAID layer (and could/should
be also optional). 

J.
