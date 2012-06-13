From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: Data Offset
Date: Wed, 13 Jun 2012 11:46:35 +0200
Message-ID: <4FD86179.1080209@pierre-beck.de>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com> <20120602095237.3822e2c2@notabene.brown> <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com> <20120604133526.6da3bf10@notabene.brown> <4FCCFDBB.201@pierre-beck.de> <20120605085728.7e922359@notabene.brown> <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com> <20120605154427.192566af@notabene.brown> <CAFhY2CiDTMRSV2wFCMhT9ZstUkHkJS7E0p7SP-ssfqwaquo+0w@mail.gmail.com> <20120610074531.65eaed81@notabene.brown> <CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: freeone3000 <freeone3000@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You specified same offset for all drives, which is wrong. Your initial 
drive setup had differing offsets - look at the examines.

In summary, we have this information:

Drive 0: offset 2048
Drive 1: offset 2048
Drive 2: offset 2048
Drive 3: offset 1024
Drive 4: -dead-

The order was also wrong. The unpartitioned drive was active device 2. 
The /dev/sdX ordering information we got is like

Drive 0: ?
Drive 1: ?
Drive 2: /dev/sde
Drive 3: ?
Drive 4: missing

That makes 3 variables. You can trial-and-error the order of drive 0, 1, 
3 but make sure the offset of drive 3 is always 1024. You'd shift 
characters only. My first try would be:

/dev/sdc3:2048s /dev/sdb3:2048s /dev/sde:2048s /dev/sdd3:1024s missing


My second try would be:

/dev/sdb3:2048s /dev/sdc3:2048s /dev/sde:2048s /dev/sdd3:1024s missing

... and so on.

And DON'T run fsck early. Try mounting read-only, take a look at your 
data. Something bigger than chunksize, like a movie file, checksum some 
iso or smth. It should be intact. THEN run fsck. fsck cannot expect raid 
stripe reordering and worst case may cause damage (not that I heard of 
it happen, but inspecting data first is safe).

Good luck,

Pierre Beck


Am 13.06.2012 08:57, schrieb freeone3000:
>   /dev/sdc3:2048s /dev/sdb3:2048s /dev/sdd3:2048s /dev/sde:2048s

