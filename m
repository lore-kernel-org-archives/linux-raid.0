From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow
Date: Wed, 1 Dec 2004 00:55:47 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412010050500.31657@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
 <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
 <Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu> <16813.418.770001.453039@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16813.418.770001.453039@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 1 Dec 2004, Neil Brown wrote:

> I don't think there is LBD support for 2.4.

found this :

https://www.gelato.unsw.edu.au/archives/lbd/2004-February/000039.html

http://www.gelato.unsw.edu.au/patches/

'Theoretically raid0 and linear should work; I'm certain raid1, raid4 and 
raid5 will not work. In any case, RAID is limited to a maximum of 2TB 
minus one block per member. '

i don't think i want this on my raid5....
