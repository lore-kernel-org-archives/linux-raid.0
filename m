From: Chris Murphy <lists@colorremedies.com>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 15:10:01 -0700
Message-ID: <CAJCQCtRdXJkaLdzDi4JuDJbjkSqX-mUj+kjrHtH6JNTLCenuuQ@mail.gmail.com>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net> <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Reindl Harald <h.reindl@thelounge.net>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 29, 2017 at 9:52 AM, Phil Turmel <philip@turmel.org> wrote:

> These are good reasons.  I have also seen reports of NAS devices/distros
> unconditionally partitioning devices that don't have one.  Although I
> have in the past used raw devices with mdadm, I don't plan to do so with
> any future systems.

I'm in this same boat. Historically I've used raw devices, no
partitioning, but I'm going to GPT partition everything from here on
out, even if it's just a single partition.

a. It makes it unambiguous this drive has had some purpose, it's not a
blank slate.
b. GPT is unambiguous, checksummed, has redundancy, and a user
definable partition name 72 bytes UTF-16E to make it even more
unambiguous
c. The MBR had too few type codes, leading to a lot of ambiguity as to
a partition's contents, so on Linux the idea was for libblkid to have
a thorough understanding of (most) every conceivable volume format
signature. But GPT solves this in a more standard way, and the
explosion of undefined volume formats and binary blobs installed on
partitions has made keeping up with their identification in blkid
increasingly challenging.

So anyway... GPT is good. And when LUKS2 gets a little farther along
the torture testing I'll move to that as well, as it too has redundant
metadata.

-- 
Chris Murphy
