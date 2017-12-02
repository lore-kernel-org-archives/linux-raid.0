From: Phil Turmel <philip@turmel.org>
Subject: Re: New setup: partitions or raw devices
Date: Sat, 2 Dec 2017 12:12:10 -0500
Message-ID: <16db34f1-34a7-bf48-9800-6f9891d1e933@turmel.org>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
 <253c22a2-8f77-2737-b3b4-6beef107c28c@youngman.org.uk>
 <14078b47-29dd-6c07-f680-77ac9445be32@thelounge.net>
 <87tvxazahs.fsf@esperi.org.uk>
 <e44e21ec-a2b3-8441-5ad3-190b4c0a8670@thelounge.net>
 <5A218EDB.6030909@youngman.org.uk>
 <1d3830e8-9e5e-681c-d556-1b8b6524dda2@thelounge.net>
 <6066a947-2a4e-d8d5-239d-dccb80e39ac0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6066a947-2a4e-d8d5-239d-dccb80e39ac0@gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Reindl Harald <h.reindl@thelounge.net>, Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Gandalf,

You and Reindl are both wrong. (-:

On 12/02/2017 08:14 AM, Gandalf Corvotempesta wrote:
> Il 02/12/2017 00:44, Reindl Harald ha scritto:
>> a RAID10 can survive two faile disks while a RAID5 is for sure dead
> Absolutely not.
> This is a common misconception.
> RAID-10 can survive two failed disks IF AND ONLY IF these disks are on
> different mirrors.

You (Gandalf) are ignoring the ability of raid10 to use multiple copies
across device counts that aren't multiples of the number of copies.  A
raid10,n3 array on five devices provides a total capacity of 1-2/3 the
capacity of one member, but can fail any two members just like a raid6.

It has blistering fast read performance, especially for parallel loads.
It has the same write performance as as similarly capacity raid0.  It
has terrible write amplification on SSDs, but is very low CPU
utilization (no parity computation and never any Read-Modify-Write cycles).

Raid10 has an valuable role to play in high performance systems, and I
use LVM on top of raid10,n3 for my own home directories, general purpose
user partitions, and the root LVs for performance-critical VMs.  I use
LVM on top of raid6 for media files, large capacity databases, and
not-so-critical VMs.

> RAID-6 is *much* more safe than RAID-1/RAID-10 as it can survive ANY TWO
> disks failure,
> you will loose data on the third failure.

You (Reindl) are crazy to argue about can-vs-will on a raid10,n2 layout.
 You're crazy to rely on any single mirror layout for data you care
about.  It is a disaster waiting to happen (during rebuild) in exactly
the same way raid5 is vulnerable during rebuild.  But raid10,n3 is just
as safe as raid6.

Phil
