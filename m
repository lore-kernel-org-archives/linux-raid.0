From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Re: converting RAID5 to RAID10
Date: Thu, 5 Oct 2006 03:25:30 -0700
Message-ID: <0069820A-6071-43D7-ACD5-EFC4A1649A79@develooper.com>
References: <20061005095913.GA2530@piper.madduck.net> <23368.194.178.120.170.1160043302.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23368.194.178.120.170.1160043302.squirrel@webmail.xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: jurriaan@rivierenland.xs4all.nl
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 5, 2006, at 3:15 AM, Jurriaan Kalkman wrote:

> AFAIK, linux raid-10 is not exactly raid 1+0, it allows you to, for
> example, use 3 disks.

I made a raid-10 device earlier today with 7 drives and I was  
surprised to see that it reported to use all of them.  I thought it'd  
make one of them a spare (or complain about the odd number of drives).

How does that work?  (Or is it the "number of drives reported" bug  
Neil referred to a moment ago?  I use FC6's version of 2.6.18).


  - ask

-- 
http://www.askbjoernhansen.com/


