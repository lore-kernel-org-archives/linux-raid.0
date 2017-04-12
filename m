From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Linux software raid troubles
Date: Wed, 12 Apr 2017 16:45:47 +0200
Message-ID: <8e9a25fc-5c81-103c-2ffa-4b46f2aa8630@thelounge.net>
References: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: linuxknight <linuxknight@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 12.04.2017 um 16:31 schrieb linuxknight:
> Last weekend I was moving a server with a raid1 configuration,
> controlled by a Intel Corporation 82801 SATA RAID Controller.  Upon
> reboot I noticed the degraded message (server hadnt been rebooted in a
> couple years).
> 
> The raid1 array was two 500gb black WD drives.  I wasnt able to locate
> an identical 500gb disk, but did find a 2TB just to get things
> mirrored again.  The bios screen accepted the replacement disk and
> said it would rebuild in the OS.  mdsync seemed to do its thing but I
> noticed mdmon process was taking 200% cpu.  I let it go a few days
> thinking it was just taking longer than normal to sync, then rebooted.
> It was in a complete failed state and wouldnt boot at all.  After
> removing the 2TB disk I was able to boot into the OS again.  I just
> assumed I needed a similar drive size for the second part of the
> mirror.

when you talk about a "SATA RAID Controller" and "The bios screen 
accepted the replacement disk and said it would rebuild in the OS" this 
sadly is not a "linux software raid" at it's own

197 Current_Pending_Sector  -O--CK   200   200   000    -    9
198 Offline_Uncorrectable   ----CK   200   200   000    -    7

i would strongly suggest https://www.gnu.org/software/ddrescue/ and make 
a image of that disk because after 39646 Power_On_Hours it's likely that 
the remaining disk fails completly in a short time and you could at 
least restore the disk-image with "dd" to a new disk if that happens as 
well as mount it with as loop-device

