From: Phil Turmel <philip@turmel.org>
Subject: Re: Data Offset
Date: Wed, 13 Jun 2012 08:49:20 -0400
Message-ID: <4FD88C50.1000104@turmel.org>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com> <20120602095237.3822e2c2@notabene.brown> <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com> <20120604133526.6da3bf10@notabene.brown> <4FCCFDBB.201@pierre-beck.de> <20120605085728.7e922359@notabene.brown> <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com> <20120605154427.192566af@notabene.brown> <CAFhY2CiDTMRSV2wFCMhT9ZstUkHkJS7E0p7SP-ssfqwaquo+0w@mail.gmail.com> <20120610074531.65eaed81@notabene.brown> <CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com> <4FD86179.1080209@pierre-beck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD86179.1080209@pierre-beck.de>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Beck <mail@pierre-beck.de>
Cc: freeone3000 <freeone3000@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/13/2012 05:46 AM, Pierre Beck wrote:

[trim /]

> And DON'T run fsck early. Try mounting read-only, take a look at your
> data. Something bigger than chunksize, like a movie file, checksum some
> iso or smth. It should be intact. THEN run fsck. fsck cannot expect raid
> stripe reordering and worst case may cause damage (not that I heard of
> it happen, but inspecting data first is safe).

This is *dangerous* advice.  Modern filesystems will replay their
journal even when mounted read-only.  When attempting to determine the
member order, mounting the file system is *not* safe.  And some
filesystems ignore the read-only status of the array, so that won't
avoid the problem.

fsck -n is the *only* safe way to automate the check.  Hex dumps of
expected signature blocks is even better, but is difficult to automate.

HTH,

Phil
