From: Timo Boettcher <spida@gmx.net>
Subject: Re: What raid to build on that drives?
Date: Wed, 26 Nov 2003 22:08:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <13534683912.20031126220814@gmx.net>
References: <3229206566.20031126203657@gmx.net>
 <4697.206.81.129.218.1069876742.squirrel@eglifamily.dnsalias.net>
Reply-To: Timo Boettcher <spida@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4697.206.81.129.218.1069876742.squirrel@eglifamily.dnsalias.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dan,


* Dan Egli , Wednesday, November 26, 2003, 8:59:02 PM:

>> Hi,
>>
>>    I have 3 * 36GB discs and 5 * 18GB discs on two u160 scsi channels?
>>    What possibilities do I have to build a raid on them? I want to be
>>    able to survive one failed disc, but get as much space and
>>    performance out of the discs as possible.
>>

> Best I can suggest is a raid 5. You'll get 72GB of space, good performance
> (roughly what you'd get from a sigle drive), and if one of the drives goes
> south, the other two will keep your raid set up till the drive can be
> replaced.

I hoped to integrate all discs in that raid....
I tried to run raid0 over pairs of the 18GB discs (leavin the fifth
as spare) and run a raid 5 over these raid0's and the three 36gb
drives, but that gives me 50mb/s reading as opposed to 100mb/s with
8*18GB raid5 on the same machine (three of these discs failed, so I
got bigger ones). Why did I loose that much performance?


 Timo

