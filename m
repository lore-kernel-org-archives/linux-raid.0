From: Mauricio <raub@afn.org>
Subject: Re: AW: Raid 1 vs 5 ?
Date: Wed, 9 Jun 2004 09:27:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <a06002007bcecbfe09c54@[10.0.0.10]>
References: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

At 07:10 +0200 5/7/04, Martin Bene wrote:
>  > Which one is the better choice and what are the trade offs? Or is
>>  another configuration more sensible? I'm under the impression that you
>>  shouldn't (can't?) boot from RAID 5.
>
>Depends very much on what you're going to do with the system - I've
>found a high performnce impact of raid5 for database applicaions with
>frequent updates (where you end up with lots of small writes scattered

	I've always thought raid1 would be slower than, say, raid0+1 
or raid5.  I guess I am wrong then. =)

>allover the partition). If write speed isn't too important, the space
>savings may well make raid5 more attractive.

	What about raid0+1 vs raid5? What is the difference?  In my 
setup, I plan on using the raid just to store user data; the machine 
would boot (/, /usr, swap, /var) from an unraid disk.
