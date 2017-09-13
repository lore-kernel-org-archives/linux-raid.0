From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Wed, 13 Sep 2017 03:34:21 +0200
Message-ID: <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
 <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3pjv6jw.fsf@esperi.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: commentsabout@riseup.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Am 13.09.2017 um 01:30 schrieb Nix:
> On 1 Sep 2017, Wols Lists stated:
>> Okay. Personal preference (and I don't do it myself, but I'd have to
>> rebuild my system to do it) I would use btrfs for the filesystems. Yes
>> it has a bad rep for its inbuilt raid, but if all you're doing is backup
>> snapshots it should be great. Each backup cycle consists of "take a
>> snapshot, do an in-place rsync", so if only 10MB of live data has
>> changed, the backup only uses an extra 10MB on the backup drives.
> 
> This sounds like downright dangerous advice to me. Surely what matters
> for backup is stability? Use something old and boring and stable. btrfs
> is the very last thing you should be thinking of for this application.
> After all, you'll only need the backups when things are already going
> wrong: the last thing you want to find is that you've been using a
> filesystem that has betrayed you at the last.

well, SuSE is using it as default for their enterprise Linux an di am 
using it on an backup-vm for two years (two 2 TB virtual disks) now 
without any problem on top of LUKS with forcec compression enabled

> ext2 is probably too old (it's not maintained much any more)

sorry, but when you are talking about betrayed filesystems above and 
then take ext2, a non journaled filesystem which takes ages for fsck, in 
your mouth....

>> Note also, I've really only covered the raid aspect. I don't know lvm, I
>> don't know btrfs.
> 
> I can tell. if you did, you wouldn't be recommending it for this
> application. btrfs is cool and all, but it's also new, and in filesystem
> land new means dangerous

with that argumentation... no i better stop comment.....
