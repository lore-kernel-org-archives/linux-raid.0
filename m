From: Timo Boettcher <spida@gmx.net>
Subject: Re: What raid to build on that drives?
Date: Wed, 26 Nov 2003 23:13:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2638591341.20031126231321@gmx.net>
References: <3229206566.20031126203657@gmx.net>
 <2804.208.48.139.163.1069883099.squirrel@www.greenhydrant.com>
Reply-To: Timo Boettcher <spida@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2804.208.48.139.163.1069883099.squirrel@www.greenhydrant.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,


* David Rees , Wednesday, November 26, 2003, 10:44:59 PM:

> On Wed, November 26, 2003 1at 1:36 am, Timo Boettcher wrote:
>>
>>    I have 3 * 36GB discs and 5 * 18GB discs on two u160 scsi channels?
>>    What possibilities do I have to build a raid on them? I want to be
>>    able to survive one failed disc, but get as much space and
>>    performance out of the discs as possible.

> How about two RAID5 arrays, one with the 3*36GB=72GB and the other using
> the 5*18GB=72GB.  Then throw both of these under a RAID0 which will get
> you 144GB and still be able to survive 1 disk failure.

that way i'll loose 54gb... but it seems reasonable...
i'll try it.


 Timo

