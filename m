From: David Greaves <david@dgreaves.com>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 08:43:14 +0000
Message-ID: <49252322.2010401@dgreaves.com>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>	 <62c47030811191213n49a50624k4a0e167f20193a4@mail.gmail.com>	 <c268e4660811191811y2b3d11d9na6bd3a64b636d217@mail.gmail.com> <d5fe39840811192328r6ddf6840y6f86683401bdf533@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d5fe39840811192328r6ddf6840y6f86683401bdf533@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
> Of course, you could always *not* yank them; instead just fail them
> (after unmounting/syncing/whatever) and leave the actual disk in the
> machine.

Also worth mentioning is that you can have a 3-way RAID1.

So adding a disk, allowing it to sync and then removing it again means you are
never left with just a single point of failure.

You can of course send the 'backup' disk(s) to sleep too.

David

