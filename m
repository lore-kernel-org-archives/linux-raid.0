From: Claudiu Rad-Lohanel <jazzman@misalpina.net>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Fri, 13 May 2016 18:33:28 +0300
Message-ID: <c28b1553-c9d0-0d9f-b232-bd6aa29d53d1@misalpina.net>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
 <5734D23D.6030400@turmel.org>
 <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
 <5734E637.6030307@turmel.org>
 <7cf56631-7909-6a92-f0b2-05dd02722ee8@misalpina.net>
 <5735DF05.8080706@turmel.org> <5735E07F.2030802@turmel.org>
 <3b4ae5f5-af19-744b-cab3-aad317ea3a82@misalpina.net>
 <20160513143923.GA23787@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160513143923.GA23787@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 5/13/2016 5:39 PM, Andreas Klauer wrote:
> On Fri, May 13, 2016 at 05:26:02PM +0300, Claudiu Rad-Lohanel wrote:
>> 1. i can't find any documentation anywhere about the --revert-reshape
>> option. how should the command look like? is it available in v3.3.2?
> IIRC it's --assemble --update=revert-reshape and it's not mentioned
> in the man page...

thanks. it would seem to do it, but, hangs, doesn't want to advance:

root@rescue /mnt # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md2 : active raid5 dm-1[0] dm-3[4] dm-2[2] dm-0[1]
       11668750848 blocks super 1.2 level 5, 64k chunk, algorithm 2 
[4/4] [UUUU]
       [===================>.]  reshape = 99.9% (3889567232/3889583616) 
finish=7338.6min speed=0K/sec


-- 
jazzman

