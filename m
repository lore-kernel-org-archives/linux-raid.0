From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Fri, 07 Jun 2013 08:18:11 -0500
Message-ID: <51B1DD93.1010904@hardwarefreak.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com> <CAAMCDefb7TFXDOD7=aK-FjHVCQXMdiQKdz=CFJT4+q9rKR3KGA@mail.gmail.com> <CAGqvA+svdBvWTbwnzQjoHWQz6n0iEaAZzmu-EqKqdPx-AK0Zkg@mail.gmail.com> <CAO9HMNE3F-ZN0fQmHW7yz2JLRFaUqSYSaVpZe3KaXuaLMojV8w@mail.gmail.com> <20130607165236.60ac7451@natsu> <CAO9HMNG2M7KDke3A0c06G47kvVWgssu7ur47BN=0goc2ELDhKQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNG2M7KDke3A0c06G47kvVWgssu7ur47BN=0goc2ELDhKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/7/2013 6:25 AM, Steve Bergman wrote:
> I don't have the source link handy, but it was an industry white
> paper. (I doubt you'll get it changed.)
> 
> There does seem to be some interface limitation here. Running "dd
> if=/dev/sdX of=/dev/null bs=512k" simultaneously for various
> combinations of drives gives me:

It's not a bus interface limitation.  The DMI link speed on the 5 Series
PCH is 1.25GB/s each way.

> Port   A alone : 155MByte/s
> Ports A & B   :  105MByte/s per drive
> Ports A, B & C: 105MBytes/s per drive for A & B. 155MBytess's for C.
> Ports A, B, C & D: 105MBytes/s per drive
> 
> So there's an aggregate limitation of ~1.7Gbit/s per port pair, with
> A&B and C&D making up the pairs.

This may be a quirk of the 5 Series Southbridge.  But note you're using
the standard ICH driver.  Switch to the AHCI driver and you may see some
gains here.  Also try the deadline elevator.  I mentioned it because I
intended for you to use it.  This wasn't an "optional" thing.  It will
improve performance over CFQ.  This isn't guesswork.  Everyone in Linux
storage knows this to be true.  As they all know to use noop with SSD
and hardware RAID w/[F|B]BWC.

Which kernel version and OS is this again?

-- 
Stan

