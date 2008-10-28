From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: dmraid - where is the raid done?
Date: Mon, 27 Oct 2008 20:12:16 -0500
Message-ID: <490666F0.4000306@gmail.com>
References: <1225120062.20830.34.camel@pc.ilinx>	 <49064EF0.4080804@gmail.com> <1225154175.16984.16.camel@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1225154175.16984.16.camel@pc.ilinx>
Sender: linux-raid-owner@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brian J. Murrell wrote:
> On Mon, 2008-10-27 at 18:29 -0500, Roger Heflin wrote:
>> After that the OS driver only reads tables that the BIOS put on the disks,
>> and figures out which disks are to be raided, and the OS does *ALL* of the work 
>> just like MD.
> 
> Ahhhh.  Really.  That is disappointing.  So in reference to the OS doing
> all of the work would that be the kernel driver for the particular RAID
> card, such as the Promise or Adaptec fakeraid cards?
> 
> b.
> 

If it is an out-of-kernel driver, then the work is being done in the 
manufacturer's driver.

If it is dmraid it is being done in the dmraid driver.

If there is no underlying hardware to run the raid on then everything has
to be done in the OS.   All of the real raid cards have at least a
really basic microprocesser on the card that takes care of things.
The higher-end cards have a lot more powerful processors.   In both
cases have a small computer on the card is what makes the hardware
raid cards cost quite a bit more than the fakeraid cards.

                    Roger
