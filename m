From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: Data Offset
Date: Wed, 13 Jun 2012 20:22:02 +0200
Message-ID: <4FD8DA4A.8030800@pierre-beck.de>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com> <20120602095237.3822e2c2@notabene.brown> <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com> <20120604133526.6da3bf10@notabene.brown> <4FCCFDBB.201@pierre-beck.de> <20120605085728.7e922359@notabene.brown> <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com> <20120605154427.192566af@notabene.brown> <CAFhY2CiDTMRSV2wFCMhT9ZstUkHkJS7E0p7SP-ssfqwaquo+0w@mail.gmail.com> <20120610074531.65eaed81@notabene.brown> <CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com> <4FD86179.1080209@pierre-beck.de> <4FD88C50.1000104@turmel.org> <4FD8D439.10406@pierre-beck.de> <4FD8D7EE.5000805@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD8D7EE.5000805@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wonder if LVM activation can be done without writing to the array? 
IIRC it updates at least some timestamp ...

Am 13.06.2012 20:12, schrieb Phil Turmel:
> It's not a question more or less dangerous.  If the stripes are out of
> order, writing to the array is destructive.  Not only will the writes
> probably land in the wrong place on the device, but writing triggers
> recalculated parity, which also probably stomps on other data.
>

