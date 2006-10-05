From: Neil Brown <neilb@suse.de>
Subject: Re: converting RAID5 to RAID10
Date: Thu, 5 Oct 2006 21:34:33 +1000
Message-ID: <17700.60873.72302.592941@cse.unsw.edu.au>
References: <20061005095913.GA2530@piper.madduck.net>
	<23368.194.178.120.170.1160043302.squirrel@webmail.xs4all.nl>
	<0069820A-6071-43D7-ACD5-EFC4A1649A79@develooper.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ask Bjorn Hansen on Thursday October 5
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Cc: jurriaan@rivierenland.xs4all.nl, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday October 5, ask@develooper.com wrote:
> 
> On Oct 5, 2006, at 3:15 AM, Jurriaan Kalkman wrote:
> 
> > AFAIK, linux raid-10 is not exactly raid 1+0, it allows you to, for
> > example, use 3 disks.
> 
> I made a raid-10 device earlier today with 7 drives and I was  
> surprised to see that it reported to use all of them.  I thought it'd  
> make one of them a spare (or complain about the odd number of drives).
> 
> How does that work?  (Or is it the "number of drives reported" bug  
> Neil referred to a moment ago?  I use FC6's version of 2.6.18).

If you wanted 6 drives and a spare you need to ask for in: -n6 -x1.
If you asked for 7 drives in a raid10 you get them.
The data is laid out thus:

   A A B B C C D
   D E E F F G G
   H H I I J J K
   K L L M M N N
(each column in a drive, each letter is a chunk of data).

NeilBrown
