From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Mon, 4 Jan 2010 22:57:48 -0800
Message-ID: <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 4, 2010 at 11:30 AM, Khelben Blackstaff
<eye.of.the.8eholder@gmail.com> wrote:

He's using SDDs with 128KByte erase blocks.

> Is there a way to make the RAID data start at a particular offset ?
> (In my case 512 sectors) ?
>
> Thank you for your time.
> --

You want the RAID data chunks aligned so that they start on a 512byte
sector address that fulfills (sector & 0xFF) == 0.

As far as I am aware, using metadata 0.90 OR 1.0 will start the actual
data at the beginning of the partition, reserve some space near the
end, and use the very end for the metadata.

Format 1.1 will reserve the space at the beginning, and I have just checked;

00000400  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00003000  (LVM2 header)

It starts the LVM2 header after 0x3000 bytes (64K chunk size); I'd
hope to see it around 0x10000.

It looks like the data isn't padded up to the desired offset.

I agree, it would be useful to have an option to specify the offset of
the first data chunk.
