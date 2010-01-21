From: Farkas Levente <lfarkas@lfarkas.org>
Subject: Re: Why does one get mismatches?
Date: Thu, 21 Jan 2010 12:48:20 +0100
Message-ID: <4B583F04.70005@lfarkas.org>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org> <70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com> <hj7vta$nvq$1@ger.gmane.org> <70ed7c3e1001201430i72023a9fq1341b671073ac53c@mail.gmail.com> <hj80v1$rap$1@ger.gmane.org> <968ea7bde37a4085f4588f2ef4447d94@localhost> <4B580B8A.5080806@shiftmail.org> <9cb28690ac0d4d79dde44b0f7c43d7d0@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9cb28690ac0d4d79dde44b0f7c43d7d0@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: Asdo <asdo@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/21/2010 11:52 AM, Steven Haigh wrote:
> On Thu, 21 Jan 2010 09:08:42 +0100, Asdo<asdo@shiftmail.org>  wrote:
>> Steven Haigh wrote:
>>> On Wed, 20 Jan 2010 17:43:45 -0500, Brett Russ<bruss@netezza.com>
> wrote:
>>>
>>> CUT!
>> Might that be a problem of the disks/controllers?
>> Jon and Steven, what hardware do you have?
>
> I'm running some fairly old hardware on this particular server. It's a
> dual P3 1Ghz.
>
> After running a repair on /dev/md2, I now see:
> # cat /sys/block/md2/md/mismatch_cnt
> 1536
>
> Again, no smart errors, nothing to indicate a disk problem at all :(
>
> As this really keeps killing the machine and it is a live system - the
> only thing I can really think of doing is to break the RAID and just rsync
> the drives twice daily :\

the same happened with many people. and we all hate it since it cause a 
huge load at all weekend on most of our servers:-(
according to redhat it's not a bug:-(

-- 
   Levente                               "Si vis pacem para bellum!"
