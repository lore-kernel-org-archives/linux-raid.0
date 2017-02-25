From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Sat, 25 Feb 2017 23:30:03 +0000
Message-ID: <58B2137B.6070608@youngman.org.uk>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
 <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
 <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aee1f55b-cedf-15e9-5865-7fc0cdf9a188@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/02/17 22:00, Phil Turmel wrote:
>> This is all a rather important usage of raid, actually, imho. It
>> > seems so obvious - create a temporary mirror, wait for the sync to
>> > complete, suspend i/o to get the disk consistent, then you can break
>> > the mirror and carry on. Terabytes :-) of data safely backed up in
>> > the space of seconds.

> No. Don't go there.  There's already a technology out there that does
> this correctly, called LVM snapshots.  And they let you resume normal
> operations after a very brief hesitation, and the snapshot holds the
> static image while you copy it off.

Will it let you put that snapshot on a hot-plug disk you can remove? For
my little system I'd quite happily mirror it off onto a hard-disk and
unplug it.

Oh - and I'm not running lvm. Not that I think there's anything wrong
with that, it's just yet another layer that I'm not (currently)
comfortable with.

Is there a sound technical reason not to go there, or is it simply a
case of "learn another tool for that job"? The less tools I have to know
the better, imho.

(Although why I'm worrying, I don't know. I know btrfs is planning to
make that obsolete :-)

Cheers,
Wol
