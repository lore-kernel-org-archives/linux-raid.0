From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Cancelling not pausing array check
Date: Mon, 6 Oct 2014 15:29:13 +0200
Message-ID: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

is it possible to cancel RAID 6 array check? echo check >
/sys/block/mdX/md/sync_action apparently only pauses it and next check
continuing from saved position. (I guess /sys/block/mdX/md/sync_min)

I want to achieve two things:

- Start check from the start of the array.

- Be sure I can shutdown array without any ill effect because check
was interrupted.

I guess that position will be cleared when array is stopped and
started again, but I dont want to guess and experiment... :)

Thanks.

Best regards,

Patrik
