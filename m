From: Peter Jonsson <dal01pjn@mds.mdh.se>
Subject: Re: Invalid superblock on drives in array
Date: Thu, 25 Dec 2003 19:22:10 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.44L.0312251859350.3919-100000@legolas.mdh.se>
References: <1072374319.3636.6.camel@binkley>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1072374319.3636.6.camel@binkley>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 25 Dec 2003, seth vidal wrote:

>
> hmm. I bet the drive labels are screwed up. For fun, stop the array,
> load up fdisk on one of the disks and type 'o' - that should make new
> dos disk labels.
>
> it's something I ran into, but this was a long time ago, so the above
> info might be out of date./
>
> so make new drive labels, repartition and recreate the array.

Well, wouldn't that destroy the data on the array? Oh well I'll redo the
array anyway. There wasn't that much data of value on the drive anyway.
I'll just loose a couple of days work.

Strange. I re-paritioned the drives, started the array with a raidstart
/dev/md0 (so it used the old raidtab) and the formatted the drive (ext3).
I mounted the filesystem and it looked ok. Then I umounted the filesystem
and stopped the array.
When I tried to start the array again I got the same problem as before.

So I changed to using persistent superblocks and did the same things. Now
it seems to work. Seems strange to me since I ran the array without
persistent superblocks since the beginning of July. Now it works and I
have once again learnt the lesson about frequent backups.


// peter
-- 
If God is real, s/he might be integer (e.g. 0). If God is complex, then s/he might be imaginary.

