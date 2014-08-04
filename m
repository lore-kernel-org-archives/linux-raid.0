From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: Are we forced to use bad blocks list?
Date: Mon, 04 Aug 2014 14:37:59 +0200
Message-ID: <53DF7EA7.2070408@shiftmail.org>
References: <53DA5340.7080507@shiftmail.org> <20140804113859.63b5ac90@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140804113859.63b5ac90@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/08/2014 03:38, NeilBrown wrote:
> On Thu, 31 Jul 2014 16:31:28 +0200 Ethan Wilson<ethan.wilson@shiftmail.org>
> wrote:
>
>> Dear MD developers,
>> it seems that with mdadm 3.3.1 , if an array has bad blocks disabled
>> ....
>> array is configured for BBL or not, and add a spare of the same type.
>>
> Why don't you want bad-block-lists?
>
> I'm not necessarily against having some why to avoid getting them
> automatically ... possibly a 'policy' option in mdadm.conf.
> But I'd like to make sure I understand all of your thinking first.
>
> Thanks,
> NeilBrown

Hello Neil,

Well... on the ML, I think that we saw the badblocks code triggered only 
once, and it was with the recent thread of Pedro Teixeira.

It seemed to me that his error condition could indicate that there might 
be a bug in the bad blocks code. It's not clear to me how those zillions 
of bad sectors could have been stored without some bug such as an 
erroneous propagation of bad blocks, or erroneous handling or degraded 
mode (he said he operated with a doubly degraded raid6 after 3 disks 
dropped out).

Additionally, when he did fsck, that should have cleared the bad blocks 
which were being written over, but he said that
"When doing a fsck.ext4 of /dev/md0 it returns the following ( and I can 
do it over and over again with the exact same errors) ..... "
I think 'exact same errors' is not supposed to happen if I understand 
the intent of BBL correctly.

So, I can't be sure, but I have the feeling it's possible that there are 
still a few bugs in the BBL code. MD RAID in general is very stable and 
I really like it so much, but maybe on production systems I'd keep the 
BBL disabled still for a while, if possible.

Thanks,
EW
