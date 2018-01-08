From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: 3-way mirror to RAID-6
Date: Mon, 8 Jan 2018 20:18:59 +0000
Message-ID: <bf2d73c1-a4d6-d4b6-bf68-e6de71d21d40@youngman.org.uk>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name>
 <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
 <063586b9-6b63-9afe-9edc-dd3a73adf1b4@turmel.org>
 <CAJH6TXiqsd=Zs4t5qAEe19shJFgSAZ1W-95yT041H6OyLbKvfA@mail.gmail.com>
 <1f497643-0ad1-5037-207a-9c999dc79ccd@turmel.org>
 <CAJH6TXj-6hyq2BM4GF0YdYQ27DAembZY0cLUt+BZKo+YySfGOw@mail.gmail.com>
 <5A538C2E.70400@youngman.org.uk>
 <CAJH6TXgdrWU0=3teNKBaVX8w9ZXgk_sqseOg4KU-UqNWTj1mBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXgdrWU0=3teNKBaVX8w9ZXgk_sqseOg4KU-UqNWTj1mBA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/01/18 15:25, Gandalf Corvotempesta wrote:
> 2018-01-08 16:20 GMT+01:00 Wols Lists <antlists@youngman.org.uk>:
>> Okay, you need spare ports to do a --replace so it's not always
>> possible, but it's always desirable. And with enough spare ports, you
>> can replace more than one drive at once, again with NO loss of redundancy.
> 
> I have 3 ports available, so I can replace 3 disks at once.
> Any hint on the exact command so that I can safely test on a test server ?
> 
Search the man page for --replace, but (off the top of my head) I think 
it's as simple as

mdadm /dev/md0 --add /dev/sdg --replace /dev/sdc

or

mdadm /dev/md0 --add /dev/sdg /dev/sdh /dev/sdi /dev/sdj --replace 
/dev/sdc /dev/sdd /dev/sde /dev/sdf

The man page says that the --replace option tells the raid code to 
failover the selected device as soon as a spare becomes available, so 
using --add --replace gives it the spare and tells it to use it.

With this number of devices to play with, I'd make sure to make a note 
of the original UUIDs and use those where possible - if linux plays with 
your sdx or you muddle your cables or whatever, then you could easily 
make an array-damaging typo ...

Cheers,
Wol
