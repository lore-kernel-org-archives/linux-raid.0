From: joystick <joystick@shiftmail.org>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 22:59:47 +0100
Message-ID: <508DAAD3.4050209@shiftmail.org>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/12 21:34, Chris Murphy wrote:
> Anyway, the idea mdadm users can't benefit from shorter ERC is untrue. 
> They certainly can. But the open question is why would they be getting 
> such long error recovery times in the first place? 7 seconds is a long 
> time. 2 minutes is a WTF moment. 

Totally agreed that 7 seconds is a way way too long time already.
Suppose the user is reading a 5MB file in a 5 disks array, that's 
(approximately) 1MB from each disk.
Suppose that in one disk you are hitting a bad area where all sectors 
are unreadable: that's a 256-sectors sequence of 7 seconds waits, that 
means HALF AN HOUR wait!
it's total nonsense

I have tried to set ERC to lower values than 7 on Hitachi drives, and 
maybe AFAIR also on WD RE, but none of the two allowed values lower 
than, IIRC, 6.0 seconds . Which is strange because the smart command 
wants 2 digits, expressed in deciseconds, so I would expect to be able 
to set the ERC to 0.1 seconds which is definitely not possible.

Any comments would be appreciated.

What Linux needs to address this feature imho is the ability to 
configure the failure actions. If the drive does not respond within 1 
second, I want the SCSI command to be aborted, device RESET, bus RESET 
or whatever (without the drive dropping out of the controller if 
possible), then an error to be returned to MD so that it starts the 
sector rewrite and goes on immediately. Do you think this would be 
possible or it would puzzle the drive?
