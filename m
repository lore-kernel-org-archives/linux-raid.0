From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 23:14:29 +0100
Message-ID: <CAJH6TXjF+vuBwGboM8HVMa88bZdn=GhgTumwJXH6qOZUso_Sjw@mail.gmail.com>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net> <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
 <CAJCQCtRdXJkaLdzDi4JuDJbjkSqX-mUj+kjrHtH6JNTLCenuuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRdXJkaLdzDi4JuDJbjkSqX-mUj+kjrHtH6JNTLCenuuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-11-29 23:10 GMT+01:00 Chris Murphy <lists@colorremedies.com>:
> a. It makes it unambiguous this drive has had some purpose, it's not a
> blank slate.
> b. GPT is unambiguous, checksummed, has redundancy, and a user
> definable partition name 72 bytes UTF-16E to make it even more
> unambiguous
> c. The MBR had too few type codes, leading to a lot of ambiguity as to
> a partition's contents, so on Linux the idea was for libblkid to have
> a thorough understanding of (most) every conceivable volume format
> signature. But GPT solves this in a more standard way, and the
> explosion of undefined volume formats and binary blobs installed on
> partitions has made keeping up with their identification in blkid
> increasingly challenging.

So, if you where me, how many gpt partition and which types would you make ?
