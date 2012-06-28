From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 20:25:44 +0200
Message-ID: <4FECA1A8.7090608@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <20120628163205.2c6a1122@notabene.brown> <4FEC1CE7.5010709@xunil.at> <4FEC2071.8010504@xunil.at> <20120628212257.5ca8fb05@notabene.brown> <4FEC7EB7.1000401@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEC7EB7.1000401@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.06.2012 17:56, schrieb Stefan G. Weichinger:

> md0 : active raid6 sdb3[4](S) sda3[5] sdc3[2] sdd3[3]
>       3903891200 blocks level 6, 64k chunk, algorithm 2 [4/2] [__UU]
>       [================>....]  recovery = 83.0%
> (1621636224/1951945600) finish=81.5min speed=67477K/sec
> 
> I assume it is OK in this state of things that sdb3 is marked as
> (S)pare ...

It seems so, as now it has entered the next stage:

md0 : active raid6 sdb3[4] sda3[0] sdc3[2] sdd3[3]
      3903891200 blocks level 6, 64k chunk, algorithm 2 [4/3] [U_UU]
      [=>...................]  recovery =  6.2% (122751744/1951945600)
finish=784.6min speed=38854K/sec

Somewhat slower, but no (S)pare there anymore.

What is the logic behind that?

What does it do exactly when it re-adds the first disk, what in the
second round?

Should I have added sd[ab]3 in one command?

To me it also seems that I now have good redundancy again already, correct?

Sorry for all my questions ;-)
I just like to understand things, at least on my user-level.

Stefan
