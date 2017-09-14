From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 13:01:51 +0100
Message-ID: <59BA6FAF.9020501@youngman.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
 <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
 <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
 <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
 <87r2v9sfkm.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r2v9sfkm.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/09/17 12:08, Nix wrote:
>> The rule is simple - don't abuse your tools, and btrfs - USED WITHIN ITS
>> > LIMITATIONS - is a powerful and reliable file system.

> Yeah, but... if you avoid the advanced features, why use btrfs? In
> particular, why use it *for a backup medium* (where such features are
> distinctly less useful than on a non-backup medium)?

Because, if you use snapshots and an "in-place rsync" (which overwrites
the part of files which have changed, rather than replacing the file by
default), then each snapshot is a full backup, but only uses the space
of an incremental.

The OP was building a backup server, so all their live data is
elsewhere, and provided you look after your backups, this will give you
a very cheap and effective backup system.

(Add to which I know nothing about XFS and ZFS, other than ZFS needs
gobs of ram and why would you want to over-provision a server that isn't
switched on unless you're backing up.)

Cheers,
Wol
