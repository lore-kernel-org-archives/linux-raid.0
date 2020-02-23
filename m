From: antlists <antlists@youngman.org.uk>
Subject: Re: mdadm RAID1 with 3 disks active on 2 disks configuration
Date: Sun, 23 Feb 2020 20:40:44 +0000
Message-ID: <1f5e671c-8d41-695b-2bc4-74df85361e75@youngman.org.uk>
References: <4cf4cbe7-989e-d7ec-cad9-cfde022bd4bf@aplu.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4cf4cbe7-989e-d7ec-cad9-cfde022bd4bf@aplu.fr>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Aymeric <mulx@aplu.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/02/2020 17:38, Aymeric wrote:
> Hello,
>
> I've a system with a RAID1 using two disks (sda + sdb) + 1 spare (sdc).
>
> For some stupid reason (cable) the spare (sdc) became active and sda was
> out the array.
>
> I then added back sda to the RAID1 but now I've RAID1 with three active
> disks and zero spare.
> I don't understand why the spare device didn't switch back as spare
> after sda have been rebuild.
Because rebuilding sda is a lot of work. The sensible option would have 
been to leave sdb and sdc active, and left sda as spare.
> I used the following command to add sda to the RAID1:
> # mdadm  /dev/md0 --add /dev/sda3
>
>
> What did I do wrong here? And how to fix it? Do I have to set sdc to
> faulty and add it back?

I'd just leave it as a 3-disk raid. But no, if you do want to set it 
back to a 2-disk raid don't do a "faulty and re-add" - that'll just make 
re-sync it again. Somehow you've got active devices set to 3, so just 
set that back to two. If you look on the wiki it covers the scenario of 
converting a three-disk raid to two.

The only thing I will add about a 3-disk raid is that if you want to 
change it to anything else, you'll have to revert to 2 first, but do 
that when you want to change things, leave it at 3 for the moment.

> Thanks!

Cheers,

Wol
