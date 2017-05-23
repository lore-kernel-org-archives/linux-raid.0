From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Tue, 23 May 2017 11:10:39 +0100
Message-ID: <87d1azx4rk.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
        <87o9ukykmk.fsf@esperi.org.uk> <592336E6.8080906@youngman.org.uk>
        <87k258y65b.fsf@esperi.org.uk>
        <871srgjrnf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871srgjrnf.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Tue, 23 May 2017 11:20:04 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 May 2017, NeilBrown outgrape:

> On Mon, May 22 2017, Nix wrote:
>
>> On 22 May 2017, Wols Lists verbalised:
>>
>> But it's only a few KiB by default! The amount of seeking needed to
>> reshape with such a small intermediate would be fairly horrific. (It was
>> bad enough as it was: the reshape of 7TiB took more than two days,
>> running at under 15MiB/s, though the component drives can all handle
>> 220MiB/s easily. The extra time was spent seeking to and from the
>> backup, it seems.)
>
> If the space before were "only a few KiB", it wouldn't be used.
> You need at least 1 full stripe, typically more.
> Current mdadm leaves several megabytes I think.

I was about to protest and say "oh but it doesn't"... but it helps if
I'm looking at the right machine. It does, but it didn't in 2009 :)

>> spindles will move the data offset such that it is (still) on a chunk or
>> stripe multiple? That's neat, if so, and means I wasted 128MiB on this,
>> uh, 12TiB array. OK I'm not terribly blown away by this, particularly
>> given that I'm wasting the same again inside the bcache partition for
>> the same reason: I'm sure mdadm won't move *that* data offset.)
>
> Data offset is always moved by a multiple of the chunk size.

Right, so the overlying fs might not be doing full-stripe writes after a
reshape, even if it thinks it is, but it will certainly be doing
chunk-multiple writes.

> When I create a 12-device raid5 on 1TB devices, then examine one of them,
> it says:
>
>     Data Offset : 262144 sectors
>    Unused Space : before=262064 sectors, after=0 sectors
>      Chunk Size : 512K

(which is 21.3... stripes.)

> so there is 130Megabytes of space per device, enough for 255 chunks.
> When mdadm moves the Data Offset to allow a reshape to happen without a
> backup file, it aims to use half the available space.  So it would use
> about 60Meg in about 120 chunks or 720Meg total across all devices.
> This is more than the 500MiB backup file you saw.

Right. The message in the manpage saying that backup files are required
for a level change is obsolete, then (and I probably slowed down my last
reshape by specifying one, since seeking to the backup file at the other
end of the disk would have been *much* slower than seeking to that slack
space before the data offset).
