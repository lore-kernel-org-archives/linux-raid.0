From: berk walker <berk@panix.com>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Fri, 27 Jan 2006 08:21:07 -0500
Message-ID: <43DA1E43.4010308@panix.com>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca> <43D8DB09.2010005@dgreaves.com> <1138286670.28634.448.camel@linux> <200601270100.54436.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601270100.54436.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:

>Hi,
>Thank  you all for all of your work on this topic.
>
>1) I apologize for my email bouncing. I have  no real choice in dsl service. 
>Perhaps I will consider cable to prevent my mail bouncing! :)
>
>2) I am able to hang 10 drives on 3 of the Promise SATA150 TX4 cards. So far 
>the construction of 5 raid1's  and mkfs.ext3 is ok without kernel  error.  
>All 10 drives are recognized by the promise BIOS (it shows drives 0-9) during 
>system turnon. I use two separate 450 W antec power supplies.
>
>If I put on 12 drives, 4 on each one, the promise bios does  not let me go 
>further. It hangs. Says something about not able to recognize hardware 
>configuration or something.
>
>This may be a hardware limitation, or even a faulty channel or two or perhaps 
>one/two  of the  additional drives is not working. I dont know. I did notice 
>this  "not booting behavior for TX4" with no adequate hints as to what is 
>going on earlier when i tried to hang a for a non funcioning sata drive on 
>the card that failed right after purchase". I tried 11 drives also and   no 
>go. only 8 or less.
>
>
>Thank you all and I will let you know what i discover..
>
>mitchell laks
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>
In the past, I've had boxes that couldn't handle all of the extra PCI 
requirements of the Promise boards.  My newer stuff seemed OK.
Email problem comment sent off-channel, pvt.
b-

