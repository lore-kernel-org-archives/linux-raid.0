From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 slow
Date: Wed, 1 Dec 2004 10:26:26 +1100
Message-ID: <16813.418.770001.453039@cse.unsw.edu.au>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
	<Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
	<Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu>
	<16811.48945.141392.294625@cse.unsw.edu.au>
	<Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
	<Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Tuesday November 30
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 30, raid@a2000.nu wrote:
> storage.a2000.nu,500G,23385,97,79328,69,59189,58,25015,91,122493,58,67.7,11,16,1404,76,+++++,+++,+++++,+++,1347,75,+++++,+++,4868,97
> 
> it's really slow... :(
> is there anything i can do ?
> i want to fill the raid asap
> 
> for now i have 2 options :
> 
> -use the 2.6 and hope someone is going to fix this ?
> 
> -use the 2.4 kernel but max 13 devices (there is no LBD support in 2.4?)
> or is there a LBD patch so i can create a 2TB+ raid5 array ?
> 
> 
I don't think there is LBD support for 2.4.

I haven't managed to duplicate the degree of slowdown that you report
- I only get about 10%.

However I found an old Email which also reported slow raid5 in 2.6 and
it noted that when the array is degraded, it goes faster ....

I just tried it and got most of the speed back when the array is
degraded!!!
Would you be able to test that option?

I will look into the code and see if I can figure out what is going
on.

NeilBrown
