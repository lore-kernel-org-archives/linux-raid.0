From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Wed, 22 Apr 2009 11:16:16 +0200
Message-ID: <87d4b5m4kf.fsf@frosties.localdomain>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	<49ED096E.1000002@anonymous.org.uk>
	<49ED16F7.3040906@anonymous.org.uk>
	<4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
	<49ED2BC3.7050109@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49ED2BC3.7050109@anonymous.org.uk> (John Robinson's message of
	"Tue, 21 Apr 2009 03:13:23 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: NeilBrown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> Can't do that, my root filesystem is on the RAID-5, and part of the
> reason for wanting the bitmap is because the md can't be stopped while
> shutting down, so it was always wanting to resync at startup, which is
> rather tedious.

Normal shutdown should put the raid in read-only mode as last step. At
least Debian does that. That way even a mounted raid will be clean
after reboot.

I would also suggest restructuring your system like this:

sdX1 1GB  raid1  / (+/boot)
sdX2 rest raid5  lvm with /usr, /var, /home, ...

Both / and /usr can usualy be read-only preventing any filesystem
corruption and raid resyncs in that part of the raid.

MfG
        Goswin
