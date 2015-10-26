From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: mdadm format for manual destriping
Date: Mon, 26 Oct 2015 15:13:15 -0400
Message-ID: <562E7B4B.2090800@turmel.org>
References: <CA+sqOsZoJn5arXKBCW6OdLkqRc4sWf_tTRv9MouBOpJEqA9uig@mail.gmail.com>
 <CA+sqOsY5UwwGbnHVQ+ctBGKo1FEOWWbAqWBmYCqo4Z6tVTL4Kw@mail.gmail.com>
 <CA+sqOsZzk3kTPK-rkvyDyhZCwBot_bOaVT8XbW5-h8c2YVn1Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsZzk3kTPK-rkvyDyhZCwBot_bOaVT8XbW5-h8c2YVn1Mw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marek <mlf.conv@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Marek,

{ Top-posting fixed.  Please don't do that. }

On 10/26/2015 02:09 PM, Marek wrote:
> On Saturday, October 24, 2015, Marek <mlf.conv@gmail.com> wrote:

>> is there a documentation available on how mdadm stores data? E.g.

Yes, the man pages.  Try "man md" and "man mdadm" in a console.  This
documentation is provide by the kernel team and, other than the source
code itself, is expected to be definitive.

>> 1.  super-block

The location of the superblock is described in "man md".  The precise
content of the superblock is only detailed in the source code.

>> 2.  offset of first block on each drive

Zero for metadata versions 0.90 and 1.0.  Configurable for metadata
versions 1.1 and 1.2.  See the --data-offset option in "man mdadm".

>> 3. whether mdadm stores blocks as raw data or stores some kind of
>> metadata associated with each block e.g. disk 1 -> data_block1
>> immidiatelly followed by data_block 5 or
>> metadata_for_block_1 | data_block 1 |  metadata_for_block_5 | data_block 5 |

No metadata per block.

>> 4. how and where mdadm stores its backup superblock

None, although each device has one.

>> 5. what klind of XOR algorithm is used by mdadm

Straight parity for raid4, raid5, and the 'P' blocks of raid6.  Galois
field arithmetic for the 'Q' blocks of raid6.

https://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

[trim /]

> Does the first block start immediately after 258 bytes?

No.

> Also question 3,4,5

See above and in the man pages.

HTH,

Phil

