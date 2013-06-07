From: Nic Wolfe <nic@wolfeden.ca>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Thu, 6 Jun 2013 22:15:22 -0600
Message-ID: <CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
	<51B0C769.1070009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B0C769.1070009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My original post had an error - sda is my boot drive, it's not part of
the array. The 6th drive is as follows:

/dev/sdg:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
  Creation Time : Wed Jun  2 21:11:18 2010
     Raid Level : raid6
  Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
     Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

  Reshape pos'n : 677888 (662.11 MiB 694.16 MB)
  Delta Devices : 1 (5->6)

    Update Time : Mon Oct 22 21:08:29 2012
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 146beaa7 - correct
         Events : 0.1323362

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5      65        0        5      active sync

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5      65        0        5      active sync



> Your reshape is barely started.  Presumably you specified a --backup
> clause in the original --grow command.  You will need that file.

Embarrassingly I have no backup file from the grow operation.

> Modern mdadm should be able to force assemble this and continue without
> problems.  Rather than operate within a questionable environment, I
> would strongly encourage you to perform the forced assembly with a
> recent live cd.  I personally use "SystemRescueCD", and I know it has
> the appropriate kernel support and tools.
>
> But.  You need to share more information about your hardware problems.
> Dmesg, etc.  There are commonly-encountered configuration problems that
> appear to be mysterious drive failures.  If you know all about error
> recovery control, please elaborate.  Otherwise, please share the output
> of "smartctl -x /dev/sdX" for all of your member devices.

My drives are connected to the machine through a poorly supported old
RAID card (rr2522) which required me to build the driver into my
kernel, so I don't think a live cd will work. I don't have enough SATA
slots in the machine to connect them all without it.

If it isn't obvious by now, I definitely don't know anything about
error recovery control.

Since it's a RAID card and not just a hba each drive is presented to
the OS as a single drive JBOD array which means the OS doesn't see any
SMART info. I can see (at least some) SMART information through my
RAID card admin console and it claims they're all fine.

I am not having hardware problems at the moment, I only encountered
them when I had 16 drives running through the RAID card (I have
another 10 drive array). With the other array disconnected the card
seems to be behaving - there's nothing suspicious that I can see in
dmesg.

In the meantime I will see if I can put together a machine with 6 SATA
ports and attempt to hook the drives up directly rather than through
the RAID card so I can use a live CD and get the SMART information for
you.

Thanks for the reply,

Nic
