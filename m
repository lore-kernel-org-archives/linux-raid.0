From: "David Rees" <dbr@greenhydrant.com>
Subject: Re: RAID design
Date: Sat, 12 Jul 2003 10:22:41 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2168.208.48.139.163.1058030561.squirrel@www.greenhydrant.com>
References: <000201c3480a$9c7ebbd0$27e703ca@magnus>
    <Pine.LNX.4.43.0307120912550.6220-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0307120912550.6220-100000@unicorn.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson said:
>
>> I am not RAID expert but I really don't see the benefits of including
>> the OS in the RAID array as if the primary HD failed, the system won't
>> be
>> able to boot anyway. Am I right ?
>
> Not neccessarily. Modern motherboards will boot of either on-board
> controller, so if the primary failed, then the master drive on the 2nd
> controller ought to be able to boot. It's worth checking your motherboard
> though. All the systems I've built in the past 2-3 years like this have
> had this ability. You may need to physically unplug the failed drive
> though (and reboot) if it fails in a way that make it look like it's still
> active.

This is where having hardware RAID is a definate advantage over software
RAID as you won't have to intervene if one of your drives has half-way
failed and the primary is detected but you can't actually read from it. 
Now that you can pick up 3ware 6xxx cards for $60-70, you can't really
complain about the price, either:

http://www.weirdstuff.com/commerce/catalog/spcategory.jsp?category_id=1267&czuid=1058030005578

-Dave
