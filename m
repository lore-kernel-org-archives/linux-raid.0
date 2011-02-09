From: David Brown <david@westcontrol.com>
Subject: Re: SSD - TRIM command
Date: Wed, 09 Feb 2011 16:49:40 +0100
Message-ID: <iiud2r$qci$1@dough.gmane.org>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>	<4D517F4F.4060003@gmail.com>	<4D5245DF.4020401@hardwarefreak.com>	<iiu4rc$9ju$1@dough.gmane.org> <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/2011 15:39, Roberto Spadim wrote:
> guys...
> if my ssd fail, i buy another...
> let's make software ok, the hardware is another problem
> raid1 should work with floppy disks, hard disks, ssd, nbd... that's the point
> make solutions for hardware mix
> the question is simple, could we send TRIM command to all mirrors (for
> stripe just disks that should receive it)? if device don't have TRIM
> we should translate it for a similar command, with the same READ
> effect (no problem if it's not atomic)
>


I've been reading a little more about this.  It seems that the days of 
TRIM may well be numbered - the latest generation of high-end SSDs have 
more powerful garbage collection algorithms, together with more spare 
blocks, making TRIM pretty much redundant.  This is, of course, the most 
convenient solution for everyone (as long as it doesn't cost too much!).

The point of the TRIM command is to tell the SSD that a particular block 
is no longer being used, so that the SSD can erase it in the background 
- that way when you want to write more data, there are more free blocks 
ready and waiting.  But if you've got plenty of spare blocks, it's easy 
to have them erased in advance and you don't need TRIM.


