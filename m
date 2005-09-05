From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: why the kernel and mdadm report differently
Date: Mon, 05 Sep 2005 15:39:50 +0200
Message-ID: <431C4AA6.2030908@bppiac.hu>
References: <431C0968.10301@bppiac.hu> <17180.3031.193961.445535@cse.unsw.edu.au> <431C30E3.2040404@bppiac.hu> <013301c5b216$78e93060$c700a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <013301c5b216$78e93060$c700a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:
> Farkas Levente wrote:
> 
>> >>this is mdadm 1.12, just another site note there is no rpm for 
>> version >>2.0:-(
>> > > > No.  I seem to remember some odd compile issue with making the RPM
>> > and thinking "I don't care".   Maybe I should care a bit more....
>>
>> would be useful.
> 
> 
> Not trying to be rude; but the install of mdadm is pathetically easy.
> Untar/Gzip the source; and type:
> 
>    make
>    make install

yes, but simply i don't like to put anything into the main filesystem 
which can't be checked later (ie. which package own it, it has the right 
checksum, etc..) and these are just with rpm. what's more i'd like to 
update packages automaticaly on all of our server from or local packages 
repository, so if i put mdadm into this list than all of our server do 
it without my manual install.

-- 
   Levente                               "Si vis pacem para bellum!"

