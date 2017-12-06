From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Tue, 5 Dec 2017 21:51:27 -0500
Message-ID: <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1865221512489329@web5g.yandex.ru>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: 002@tut.by, Jeremy Graham <jeremy@doghouse.agency>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/05/2017 10:55 AM, 002@tut.by wrote:
> A well known reason for this behavior are bad blocks in device's BBL,
> which you happen to have:

[trim /]

> This feature generally shouldn't be used, because its implementation
> is unfinished. Empty BBL's can be removed from every device by giving
> "--update=no-bbl" option to mdadm on assemble, but before that you
> must manually regenerate content for each block in BBL's and then
> manually zero the lists in superblocks.

I endorse this opinion.  The BBL should never have been merged as-is.
Without a block reallocation system like a real hard drive, a BBL entry
simple drops redundancy on the block in question without any other
corrective action.

Completely, utterly, brain-dead.

At the very least, it should not be enabled by default on new arrays.

Phil
