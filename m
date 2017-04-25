From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 13:08:07 +0200
Message-ID: <20170425110807.GA5159@metamorpher.de>
References: <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 25, 2017 at 12:40:37PM +0200, Patrik Dahlström wrote:
> I was thinking if it was in fact a 5 disk raid + garbage from 1 disk,
> then the checksum would be correct if the garbage disk was filtered
> out. Does that make sens?

No. With one disk missing there is no parity (no way to verify it).

> You mentioned something about linear device mapping before. What is
> that? Is it something I could experiment with? How do I do that?

https://www.kernel.org/doc/Documentation/device-mapper/linear.txt

Once you have found where data overlaps on both raids, you create 
a linear mapping of start..X of the 6disk raid, followed by X..end 
of the 5disk RAID.

That way you get a device that holds your data intact as a whole, 
whereas the raid sets would give you the first half of data on 
the 6disk raid set (what was already reshaped) and the other half 
on the 5disk raid set (what had yet to be reshaped).

This is only a way to get read access at the data, making the raid 
work as a standalone again (resume reshape with lost raid metadata) 
is another problem, to be tackled after you backed up your data ;)

> Output of examine calls:

> /dev/mapper/sda:
>     Data Offset : 252928 sectors

> /dev/mapper/sda-2:
>     Data Offset : 252928 sectors

Wrong.

mdadm --grow changes the offset, so:

The 5disk raid should have the original offset 
(presumably 128M, 262144 sectors)

The 6disk raid should have the new offset 
(where you found your already reshaped ext4 filesystem header)

Regards
Andreas Klauer
