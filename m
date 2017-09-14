From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 19:01:02 +0200
Message-ID: <ba7e431d-2bec-313e-eb3c-51cb7c3f47c8@thelounge.net>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
 <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
 <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
 <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
 <87r2v9sfkm.fsf@esperi.org.uk> <59BA6FAF.9020501@youngman.org.uk>
 <878thhsa0w.fsf@esperi.org.uk> <20170914183932.001ffe25@natsu>
 <87wp51qq60.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wp51qq60.fsf@esperi.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 14.09.2017 um 17:02 schrieb Nix:
> On 14 Sep 2017, Roman Mamedov said:
> 
>> On Thu, 14 Sep 2017 14:08:15 +0100
>> Nix <nix@esperi.org.uk> wrote:
>>
>>> Backups based on not-yet-reliable filesystems are, uh, less effective.
>>
>> You're just grasping for straws at this point. Single-device Btrfs and
>> its core features like snapshotting and compression are very solid, it is
>> silly trying to "cast doubt" on those.
> 
> I'm not grasping for straws, but I do think I'm a lot more conservative
> than you where backups are concerned!

depends also on the type of backup, normally you have more than once anyways

* microserver with NFS, dedicated to run a vmware backup-appliance
* that beast holding 31 days of anything is backuped
   once per month on a external disk, there are two identical
   external disks, one is always located off-house and both
   are containing the *supsended* backup appliance inclduding memory

so, and the btrfs backup machine is located on the other side of the 
town, does dauly backups and rnshshot for 7 days and is reachable via 
ssh/sftp and key-auth - that one is mostly for "i have deleted a single 
file or folder can you restore it"

why BTRFS?
because of the compression!

the other stuuf above is 1 time XFS and the external disks ext4

*that* is how a backup plan looks like because when you lose your 
complete backup because one damaged filesystem you have no backup plan 
at all (take it offeding if you want to do so...)


