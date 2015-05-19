From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Backup raid, power down questions.
Date: Tue, 19 May 2015 13:54:57 +0100
Message-ID: <555B32A1.8010900@youngman.org.uk>
References: <BLU437-SMTP474BC966B5944E3445207D98C30@phx.gbl> <20150519174606.4f7e8e75@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150519174606.4f7e8e75@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/05/15 13:46, Roman Mamedov wrote:
> On Tue, 19 May 2015 13:36:43 +0100 "Wilson, Jonathan"
> <piercing_male@hotmail.com> wrote:
> 
>> I am looking to create a second raid6 set which will only be used
>> to do periodical backups of the main raid6, probably using rsync.
>> (all drives will be tler'able WD reds)
> 
>> Obviously when the system boots all the raids will start up
> 
> With both RAIDs in the same case, sharing a PSU, connected to the
> same system? I'd say forget about it, that's a terrible way to have
> a "backup", too many things that can go wrong affecting both RAIDs
> at once. Starting with a power supply failing and frying all the
> drives, and ending with an unauthorized access via some root
> exploit, with the intruder deleting all data or dd'ing zeroes to
> all drives.
> 
> Throw together a separate inexpensive computer and back up to that.
> Can even power off it entirely when not in use and power-on either
> by Wake On Lan or by schedule (most x86 BIOSes have a feature to
> power-on the machine daily at a specified time).
> 
And while it's a bit off-topic here, I'd seriously look at that backup
computer using btrfs rather than raid. You can configure it to
duplicate all files to two disks, giving you a fault tolerant backup,
and you can set it to boot up, snapshot the drive, do an IN PLACE
rsync (which means the new snapshot/backup only uses diskspace for
stuff that's changed), and shuts down again or whatever. So you can
have multiple backups going back yonks without too much disk space
being wasted.

And while btrfs does have some pretty serious flaws still, it seems
the bulk of them are triggered by the system running out of space.
That shouldn't be a problem if you keep an eye on it.

Cheers,
Wol
