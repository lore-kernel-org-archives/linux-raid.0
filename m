From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid6 recovery
Date: Sun, 22 Mar 2020 00:05:06 +0000
Message-ID: <5E76ABB2.9010506@youngman.org.uk>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
 <5E75163B.2050602@youngman.org.uk>
 <CA+9eyigMV-E=FwtXDWZszSsV6JOxxFOFVh6WzmeH=OC3heMUHw@mail.gmail.com>
 <ab2a40b6-b4ab-9ff8-aef6-02d8cce8d587@youngman.org.uk>
 <CA+9eyig8U2Tzi1wF97k7eDu5vKg5Jc2sRXKaw0OCy7Cbc9HMog@mail.gmail.com>
 <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c55be05d-22ee-4676-7878-5bf99ccc80f9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Glenn Greibesland <glenngreibesland@gmail.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 21/03/20 19:24, Phil Turmel wrote:
> If UREs do break your array again, you will need to use an
> error-ignoring copy tool (some flavor of ddrescue) to put the readable
> data onto a new device, remove the old device from the system, and then
> --assemble --force with the replacement.  Repeat as needed.

I would NOT recommend it at the moment - it's untested and reputedly
breaks raids 5 & 6, but look at dm-integrity. If we could trust it, it
would be a wonderful tool with ddrescue.

Hopefully I'm about to have a wonderful system with 6 or so drives I can
play with as a raid test-bed, and I'm hoping to do a load of work on this.

Cheers,
Wol
