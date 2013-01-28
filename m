From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: help recovering a software raid5 device
Date: Sun, 27 Jan 2013 17:59:35 -0800
Message-ID: <7l2ht9xg3a.ln2@goaway.wombat.san-francisco.ca.us>
References: <CAAXKdzzERB_zzcdPPzuwdL+afFO334X3bck1EvrRV5rFvEEg6Q@mail.gmail.com>
 <5105D435.8090401@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-01-28, Phil Turmel <philip@turmel.org> wrote:
> On 01/27/2013 08:52 AM, Theo Cabrerizo Diem wrote:
>> 
>> I did read the wiki, and took a copy of mdadm --examine /dev/sd[ghij]1
>> before doing anything. I've tried to run :
>> 
>> mdadm --create --assume-clean --level=5 --chunk 64 --raid-devices=4
>> /dev/md/stuff1 /dev/sdh1 /dev/sdg1 /dev/sdj1 /dev/sdi1
>
> For some reason, people are unwilling to use "--assemble --force", which
> is made for these situations.

It is because the wiki suggests the --create --assume-clean strategy:

https://raid.wiki.kernel.org/index.php/RAID_Recovery

I thought I modified that page, but perhaps I am misremembering, or
perhaps I wasn't sure of the best advice to put there.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


