From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID down, dont know why!
Date: Mon, 09 Nov 2009 16:23:07 -0500
Message-ID: <4AF8883B.5030906@gmail.com>
References: <4AF6CEFD.60309@gmail.com> <4AF6D099.5040407@scalableinformatics.com> <4AF82D29.507@harddata.com> <4AF82DE4.2040805@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF82DE4.2040805@scalableinformatics.com>
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com, linux-raid@vger.kernel.org
Cc: Maurice Hilarius <maurice@harddata.com>
List-Id: linux-raid.ids

Its something different than hardware, I am getting random failures now,
as in:

Normal (X marks no drive even present, U marks a drop):
A B X X
C D X X
E F X X
G H I X

First loss:

A B X X
C D X X
U U X X
U U I X

Second Loss:

First loss:

U U X X
C D X X
E U X X
G H U X

Just dropping randomly.

I had the system running under ubuntu 9.04 server for 1 month without
ever seeing this, it wont run an hour without this issue now. Currently
trying to find my 9.04 disk so I can just go back, I need this thing
online by wednesday.

I wish I could have easily gotten more information for everyone, this is
a huge problem for people with my setup. I think its possibly a
controller driver thing.




Joe Landman wrote:
> Maurice Hilarius wrote:
>> Joe Landman wrote:
>>> Andrew Dunn wrote:
>>>> I just copied 4+ TiB of information to this array, restarted 5 times
>>>> and tried to access it.... What is going on?
>>>
>>> It looks like you have 4 failed drives. sdl,sdi,sdj,sdk
>>>
>>>
>> Exactly.
>> Looks like one multilane cable is disconnected.
>> Each "feeds" 4 drives.
>> a b c d
>> e f g h
>> i j k l
>
> Yes.  Tha is what I was thinking.  I asked Andrew to reseat cables,
> and check to make sure that power is going to the block on the
> backplane or mobile storage cannister.
>
>
>

-- 
Andrew Dunn
http://agdunn.net

