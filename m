From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 10 / 2 Devices Layout question
Date: Sun, 26 Jun 2016 13:34:05 -0400
Message-ID: <5770120D.9050809@turmel.org>
References: <CA+3OdkMoF7jZNwsNR282Hvq4qwsKUuPtXaXrKXNUPq_4YD6BDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+3OdkMoF7jZNwsNR282Hvq4qwsKUuPtXaXrKXNUPq_4YD6BDw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Roland <paulrolandw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/26/2016 01:20 PM, Paul Roland wrote:

> I have two SSDs, and I would like to use md/raid10 (2devices) for
> performance reasons.

Ok, that's reasonable.

> Is using near instead of N2 somehow less secure than F2?

{ First, "near" == "near2" == "n2".  Linux raid10 defaults to two copies
of each data block.  "near3" == "n3" would be three copies of each data
block.  Et cetera. }

No.  The far layouts have exactly the same redundancy as the
corresponding near or offset layout.  The far layouts are intended to
provide a slight performance boost based on the difference in linear
head velocity on spinning disks between the outer edge and the hub.  It
has no advantage on SSDs.

The near layouts are equivalent to mirrors when using the same number of
disks as number of copies.  The near layouts are equivalent to mirrors
of raid0 stripes when the number of disks is a multiple of the number of
copies.

HTH,

Phil
