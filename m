From: jim owens <jowens@hp.com>
Subject: Re: MD performance options: More =?windows-1252?Q?CPU=92s_or_?=
 =?windows-1252?Q?more_Hz=92s=3F?=
Date: Wed, 04 Nov 2009 10:56:54 -0500
Message-ID: <4AF1A446.700@hp.com>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>	 <4AF18A39.6010404@tmr.com> <66781b10911040634mcdc3c70jec3410c09003fb6c@mail.gmail.com> <4AF1A0B8.2080807@hp.com> <4AF1A1B4.2030405@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1A1B4.2030405@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

jim owens wrote:
>> So the proper comparison of raid6 software overhead is to
>> run the same application writing a fixed large amount of data
>> to 4 drives at raid0 and the same 4 drives at raid6.

Actually, it is probably better to run the application with

   2 X data to raid0 and 1 X data to raid6

so the amount of written disk data is the same.

That way the comparison will remove the bus/disk difference
caused by sending different amounts of data and:

overhead = raid6_time - raid0_time;

jim
