From: Marek <mlf.conv@gmail.com>
Subject: Fwd: mdadm format for manual destriping
Date: Mon, 26 Oct 2015 19:09:47 +0100
Message-ID: <CA+sqOsZzk3kTPK-rkvyDyhZCwBot_bOaVT8XbW5-h8c2YVn1Mw@mail.gmail.com>
References: <CA+sqOsZoJn5arXKBCW6OdLkqRc4sWf_tTRv9MouBOpJEqA9uig@mail.gmail.com>
	<CA+sqOsY5UwwGbnHVQ+ctBGKo1FEOWWbAqWBmYCqo4Z6tVTL4Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsY5UwwGbnHVQ+ctBGKo1FEOWWbAqWBmYCqo4Z6tVTL4Kw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have found the following link which answers question 1.
But there's more stuff that's seems undocumented
https://raid.wiki.kernel.org/index.php/RAID_superblock_formats
Question 2
Does the superblock of size 256+2 start at 0?
Does the first block start immediately after 258 bytes?
Also question 3,4,5

Marek

On Saturday, October 24, 2015, Marek <mlf.conv@gmail.com> wrote:
>
> Hi,
>
> is there a documentation available on how mdadm stores data? E.g.
> 1.  super-block
> 2.  offset of first block on each drive
> 3. whether mdadm stores blocks as raw data or stores some kind of
> metadata associated with each block e.g. disk 1 -> data_block1
> immidiatelly followed by data_block 5 or
> metadata_for_block_1 | data_block 1 |  metadata_for_block_5 | data_block 5 |
> 4. how and where mdadm stores its backup superblock
> 5. what klind of XOR algorithm is used by mdadm
>
> thanks,
>
> Marek
