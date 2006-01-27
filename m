From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Fri, 27 Jan 2006 01:00:54 -0500
Message-ID: <200601270100.54436.mlaks@verizon.net>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>
 <43D8DB09.2010005@dgreaves.com> <1138286670.28634.448.camel@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1138286670.28634.448.camel@linux>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Thank  you all for all of your work on this topic.

1) I apologize for my email bouncing. I have  no real choice in dsl service. 
Perhaps I will consider cable to prevent my mail bouncing! :)

2) I am able to hang 10 drives on 3 of the Promise SATA150 TX4 cards. So far 
the construction of 5 raid1's  and mkfs.ext3 is ok without kernel  error.  
All 10 drives are recognized by the promise BIOS (it shows drives 0-9) during 
system turnon. I use two separate 450 W antec power supplies.

If I put on 12 drives, 4 on each one, the promise bios does  not let me go 
further. It hangs. Says something about not able to recognize hardware 
configuration or something.

This may be a hardware limitation, or even a faulty channel or two or perhaps 
one/two  of the  additional drives is not working. I dont know. I did notice 
this  "not booting behavior for TX4" with no adequate hints as to what is 
going on earlier when i tried to hang a for a non funcioning sata drive on 
the card that failed right after purchase". I tried 11 drives also and   no 
go. only 8 or less.


Thank you all and I will let you know what i discover..

mitchell laks
