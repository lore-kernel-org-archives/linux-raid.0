From: Adam Thompson <athompso@athompso.net>
Subject: Re: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Tue, 10 Feb 2015 21:26:32 -0600
Message-ID: <54DACBE8.70106@athompso.net>
References: <54DAB614.70302@athompso.net> <54DAC0E2.2070303@turmel.org> <54DAC42F.3090600@athompso.net> <54DAC7A4.40407@turmel.org>
Reply-To: athompso@athompso.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DAC7A4.40407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 2015-02-10 09:08 PM, Phil Turmel wrote:
> Hi Adam,
>
> { Dropped members-only lists from CC }
>
> On 02/10/2015 09:53 PM, Adam Thompson wrote:
>
>>> [root@muug ~]# mdadm --verbose --misc --run --readonly /dev/md127
>>> mdadm: /dev/md127 does not appear to be active.
>>
>> Also, kernel 3.19, which I mentioned we're running, pretty much *is* my
>> definition of an up-to-date kernel... how much newer do you want me to
>> try, and where would you recommend I find such a thing in a bootable image?
> You're right, 3.19 should be fine.  I'm stumped.  Looks like a bug.
> Adding Neil ....
>
> Phil

One thing I just remembered... this was originally a nine-drive array 
that got expanded.  The server has been rebooted many times since then, 
however, without incident until tonight.

-- 
-Adam Thompson
  athompso@athompso.net
  +1 (204) 291-7950 - cell
  +1 (204) 489-6515 - fax

