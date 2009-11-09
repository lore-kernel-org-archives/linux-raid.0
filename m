From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Doubt
Date: Mon, 09 Nov 2009 12:48:58 -0500
Message-ID: <4AF8560A.4020001@tmr.com>
References: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Light King <thelightking@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Light King wrote:
> i have four cf card and i have one pci based cf card
> contoller(addonics card with pata_sil6800 driver).when i am connecting
> this four cf card to addonics card(which has four slots for cf cards)
> and inserting this total hardware package to pci slot of pc in linux
> os it is showing four different block devices to me.So using mdadm
> 2.6.3 software raid i am creating a raid device of level 0 . If one cf
> card from this hardware package getting failed the raid-device is
> becoming inactive .If i am trying to reactive the raid device using
> mdamd -R command it is giving a error of "memory cannot be allocated
> for the raid device " .The same thing i am trying with raid10 (our
> hardware only supports raid  level 0 ,1,10) and if one cf card got
> failed we are abel to reactive the raid device.But  the issue we are
> facing in raid10 is it is taking 50%(2-CF card out of 4) of total
> memory space as mirroring which is a loss for us .
>
> So we dont want any kind of data recovery in our raid device (like
> raid0) but we want if one cf card failed also, the raid device should
> run or should reactive without any error(like raid10) but we should
> abel to use the total disk space (like raid0).
>
> or
>
> any idea to increase size of storage memory created by raid10 (50% is
> going waste due to mirroring and our hardware doesnot support raid5) .
>   

If I understand what you are asking, when one part of your array fails, 
you want to throw away all the data on all the devices and create a new 
array using the remaining functional devices. I guess you could run a 
script to do that, but only if you put the controller in JBOD mode so 
software raid can manipulate the individual devices. Then you could use 
the drive fail event to trigger the script.

If that isn't what you want, have a go at explaining what you want to 
happen when a device fails. Bear in mind that with raid0 when any one 
fails all of your data is gone. Period. You have traded capacity and 
performance for reliability, so there is no recovery other than start 
over using the working bits.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

