From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Confused about UUID mounting and mirrors
Date: Tue, 17 Jun 2008 11:11:16 +0400
Message-ID: <48576394.8090609@msgid.tls.msk.ru>
References: <4856A8C6.3030609@kmaclub.com> <4856CFE1.1020105@ziu.info> <4856DB4C.20905@kmaclub.com> <4856DD5B.9050303@dgreaves.com> <485721A5.3080101@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <485721A5.3080101@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: David Greaves <david@dgreaves.com>, Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@kmaclub.com wrote:
[]
> mdadm --detail /dev/md0 | grep UUID
>            UUID : 3531a48d:1180bdf3:bfcd9e76:5b7e5957

This is a RAID (md) -- i.e., device, UUID.  Think of it
as of disk drive serial number for example -- look at
/dev/disk/by-id/.

> mount -U 3531a48d:1180bdf3:bfcd9e76:5b7e5957 /mnt
> mount: no such partition found

And mount expects *filesystem* UUID, not a device UUID.
I.e., the UUID which was written by mkfs.  For a ext[234]fs,
tune2fs -l /dev/md0 will show it; for other filesystems
use appropriate tools.

/mjt
