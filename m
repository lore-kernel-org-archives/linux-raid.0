From: Mathieu Chouquet-Stringer <mathieu@newview.com>
Subject: Re: broken disk?
Date: Mon, 8 Apr 2002 17:25:44 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020408172544.A24718@shookay.newview.com>
References: <xltsn65apm6.fsf@shookay.newview.com> <Pine.LNX.4.33.0204082321210.1436-100000@kopernikus.tux-web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0204082321210.1436-100000@kopernikus.tux-web.de>; from gernot@tux-web.de on Mon, Apr 08, 2002 at 11:23:29PM +0200
To: "Gernot A. Weber" <gernot@tux-web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 08, 2002 at 11:23:29PM +0200, Gernot A. Weber wrote:
> Hi Mathieu,
> >
> > I don't know for sure if the disk is broken but the device 08:25 is
> > /dev/sdb9 (you can grep for the major:minor number in /dev or just take a
> > look in linux/Documentation/devices.txt)
> >
> Mhm, I only have 7 partitions on sdb... and sometimes I get the same
> message with 08:26 and 08:27...

Could it be in hexadecimal? In this case:
08:25 would be sdc5
and so on
 

-- 
Mathieu Chouquet-Stringer              E-Mail : mathieu@newview.com
    It is exactly because a man cannot do a thing that he is a
                      proper judge of it.
                      -- Oscar Wilde
