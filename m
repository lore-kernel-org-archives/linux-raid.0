From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Bit-Rot
Date: Mon, 6 Mar 2017 13:45:32 +0100
Message-ID: <313e96f3-70e6-aaa1-8aaa-0183efb8253d@thelounge.net>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
 <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk>
 <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
 <alpine.DEB.2.02.1703050913530.30226@uplift.swm.pp.se>
 <20170306115648.GG7497@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170306115648.GG7497@reaktio.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 06.03.2017 um 12:56 schrieb Pasi Kärkkäinen:
> On Sun, Mar 05, 2017 at 09:15:39AM +0100, Mikael Abrahamsson wrote:
>> On Fri, 3 Mar 2017, Gandalf Corvotempesta wrote:
>>
>>> This is what ZFS does. This is what Gluster does. This is what BRTFS does.
>>> Adding this in mdadm could be an interesting feature.
>>
>> This has been discussed several times. Yes, it would be interesting.
>> It's not easy to do because mdadm maps 4k blocks to 4k blocks. Only
>> way to "easily" add this I imagine, would be to have an additional
>> "checksum" block, so that raid6 would require 3 extra drives instead
>> of 2.
>>
>> The answer historically has been "patches welcome".
>
> There was/is an early prototype implementation of checksums for Linux MD RAID:
>
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-presentation.pdf
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-paper.pdf
> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-code.tar.bz2

well, it would help when the raid-check just verify that in a RAID10 
both mirrors of the stripe have identical data and not just wait for a 
read-error of the drives

given that when you mix HDD/SSD and after the first fstrim which only 
affects the SSD sha1sum of the first MB no longer matches while it does 
on a 4 drive HD array while both machines are clones that is not the case
________________________________________

machine 1 running since 2011

for disk in sda2 sdb2 sdd2 sdc2
do
  echo -n "$disk = ";
  dd if=/dev/$disk bs=1M skip=10 count=10 2>/dev/null | sha1sum
done

sda2 = 61efc1017cac02b1be7a95618215485b70a0d18d  -
sdb2 = ac4ec9b1a96c9c6bbd9ba196fcb7d6cd2dbb0faa  -
sdd2 = ac4ec9b1a96c9c6bbd9ba196fcb7d6cd2dbb0faa  -
sdc2 = 61efc1017cac02b1be7a95618215485b70a0d18d  -
________________________________________

the same on a cloned machine (just take two of the drives to the other 
machine and resync both with 2 new drives)

sda2 = 766fde5907aebc4dca39e31475b295035c95e3b4  -
sdb2 = 4f4b7f3b8f8893b2fb2f0f8b86944aa88f2cf2b6  -
sdd2 = 940ecae52580759abb33328dc464a937a66339ba  -
sdc2 = 9f79a56f0f09bb422a8d40787ca28cb719866e8e  -
________________________________________

* remove the 2 HDD on the mixed one
* overwrite it with zeros
* add them and wait rebuild
* sha1sum is identical
* fstrim -a
* sha1sum mismatch
* no alter from "raid-check"

you can repeat that as often as you want with the same results, the 
simple reason is that when on that first MB a free ext4 blocks on top 
after fstrim the SSD returns zeros while the HDD don't
________________________________________

and yes i am aware that someone or automatism needs to make a decision 
which of the 2 halfs is the truth but at least it should alert by default
