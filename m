From: Mathieu Chouquet-Stringer <mathieu@newview.com>
Subject: Re: broken disk?
Date: 08 Apr 2002 16:42:57 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <xltsn65apm6.fsf@shookay.newview.com>
References: <Pine.LNX.4.33.0204082219000.845-100000@kopernikus.tux-web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.33.0204082219000.845-100000@kopernikus.tux-web.de>
To: "\"Gernot A. Weber\"" <gernot@tux-web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

        Hi Gernot!
        
gernot@tux-web.de ("Gernot A. Weber") writes:
> Is the disk broken? And - WHICH disk is it (I assume it's the disk with
> ID2, but is there a map, which tells me the meaning of Device 08:25?)?

I don't know for sure if the disk is broken but the device 08:25 is
/dev/sdb9 (you can grep for the major:minor number in /dev or just take a
look in linux/Documentation/devices.txt)

> Apr  8 09:18:25 kopernikus kernel: (scsi0:A:2:0): Locking max tag count at
> 64
> 
> Are these serios?

No, this one is ok: it means the drive is able to handle 64 tags at most
(and you're scsi driver probably defaulted to a higher value).

Mathieu. 

-- 
Mathieu Chouquet-Stringer              E-Mail : mathieu@newview.com
    It is exactly because a man cannot do a thing that he is a
                      proper judge of it.
                      -- Oscar Wilde
