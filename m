From: Alex Pientka <alex.pientka@gmail.com>
Subject: Re: strange partition table and slow speeds
Date: Mon, 17 Dec 2012 12:26:48 -0500
Message-ID: <CA+Z7oPi47kj9NyigH6TBZ+CyfW5u-5vHk3fUsKMEVR-7kSwayQ@mail.gmail.com>
References: <CA+Z7oPgjAsj3f571ocN9zS2sGjgdMsK97_H6qR20o1GPUJYVKQ@mail.gmail.com>
 <50CF53F2.30404@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50CF53F2.30404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I assume upgrading to v1.2 is not possible. The only other way would
be to fail every raw device (one-by-one) and then create the fd
partition on it, correct?
Alex


On Mon, Dec 17, 2012 at 12:18 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Alex,
>
> On 12/17/2012 09:17 AM, Alex Pientka wrote:
>
> [trim /]
>>
>> /dev/md0:
>>         Version : 1.1
>
>                    ^^^^^
> You've deliberately chosen a metadata version that places the superblock
> at sector 0 of the given device.  If that is a whole disk, it overwrites
> the partition table.  The default metadata is v1.2 (which places the
> superblock at offset 4k) for this very reason.
>
> HTH,
>
> Phil
