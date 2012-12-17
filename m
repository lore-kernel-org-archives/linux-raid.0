From: Phil Turmel <philip@turmel.org>
Subject: Re: strange partition table and slow speeds
Date: Mon, 17 Dec 2012 12:41:54 -0500
Message-ID: <50CF5962.3070007@turmel.org>
References: <CA+Z7oPgjAsj3f571ocN9zS2sGjgdMsK97_H6qR20o1GPUJYVKQ@mail.gmail.com> <50CF53F2.30404@turmel.org> <CA+Z7oPi47kj9NyigH6TBZ+CyfW5u-5vHk3fUsKMEVR-7kSwayQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Z7oPi47kj9NyigH6TBZ+CyfW5u-5vHk3fUsKMEVR-7kSwayQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Pientka <alex.pientka@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Top-posting repaired.  Please don't.]

On 12/17/2012 12:26 PM, Alex Pientka wrote:
> On Mon, Dec 17, 2012 at 12:18 PM, Phil Turmel <philip@turmel.org> wrote:
>> Hi Alex,
>>
>> On 12/17/2012 09:17 AM, Alex Pientka wrote:
>>
>> [trim /]
>>>
>>> /dev/md0:
>>>         Version : 1.1
>>
>>                    ^^^^^
>> You've deliberately chosen a metadata version that places the superblock
>> at sector 0 of the given device.  If that is a whole disk, it overwrites
>> the partition table.  The default metadata is v1.2 (which places the
>> superblock at offset 4k) for this very reason.

> I assume upgrading to v1.2 is not possible. The only other way would
> be to fail every raw device (one-by-one) and then create the fd
> partition on it, correct?

You could put the array back on partitions if you like.  I'd make a
complete backup, zero the superblocks, and use --create --assume-clean
to switch to v1.2 in place (with due care to maintain the device order
and data offsets).

(Save the output of "mdadm -E /dev/sdXX" for each member device before
you start.)

However, that fdisk can't understand the partition table shouldn't be
hurting anything, so I wouldn't make it a priority.

BTW, partition type 'fd' is deprecated along with v0.90 metadata, as it
only impacts kernel non-initramfs autoassembly, and that only works with
DOS partition tables and v0.90 metadata.

Phil
