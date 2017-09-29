From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Is the LSI SAS9211-8i still the go to HBA?
Date: Fri, 29 Sep 2017 12:37:11 -0500
Message-ID: <5819b1af-1da3-7c64-31d0-574395faa31b@gmail.com>
References: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au>
 <77d0cd80-40b3-acb2-ba8a-e3650ad1b734@aei.mpg.de>
 <20170928085255.i6ogmdyf6xwic5kv@vault.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928085255.i6ogmdyf6xwic5kv@vault.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/28/2017 03:52 AM, Johannes Truschnigg wrote:
> On Thu, Sep 28, 2017 at 10:40:43AM +0200, Carsten Aulbert wrote:
>> Hi
>>
>> On 09/28/17 10:34, Eyal Lebedinsky wrote:
>>> [...]
>>> So, is there another candidate for 8 way HBA for use with linux software
>>> raid?
>> We operate a couple of SAS3008 based cards from Broadcom formerly known
>> as Avago formerly known as LSI ;)
>>
>> E.g. the 9300-8i card which we flashed ourselves from IR to IT mode work
>> quite nicely without any complain at the moment.
> Same here - just make sure to flash a recent-ish firmware image. The 3008 was
> unusable garbage before the (iirc) "P8" release for us.
>
I have 9211 (for about 9 months). Had to flash IT firmware. It is a bit 
slow in enumerrating attached disks and sometimes kernel misses a disk 
or two at boot up that shows up afterwards.  This kind of messes up md. 
I suspect this is more of the problem with ubuntu 14.04 I have, rather 
than md or 9211 problem. However, simple re-add fixes it. Since upgrade 
to newer version is a problem for me, I am just dealing with it. So, you 
may not even have this problem.

Ramesh

