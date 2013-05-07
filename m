From: Ole Tange <tange@binf.ku.dk>
Subject: Re: --grow RAID6 gives: md: md_do_sync() got signal ... exiting + hang
Date: Tue, 7 May 2013 13:56:55 +0200
Message-ID: <CANU9nTnGL8pR9Qnp_W-akDHz-ruqVOu5TLgJAE5aTTNC9DeOpQ@mail.gmail.com>
References: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANU9nTmqXjPFqU=p0vex2SgXjyv9L2NO5mafHoWqfH7n1kkhcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 7, 2013 at 1:36 PM, Ole Tange <tange@binf.ku.dk> wrote:

> I am expanding my 9 harddisk RAID6 to 10 harddisk RAID6:
:
> It is, however, hanging the system.

I can mdadm -E:

/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 242d6530:e2562ecb:1dcd2a97:15a1a868
           Name : lemaitre:1  (local to host lemaitre)
  Creation Time : Mon Nov  5 16:27:45 2012
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 7814035120 (3726.02 GiB 4000.79 GB)
     Array Size : 31256138752 (29808.18 GiB 32006.29 GB)
  Used Dev Size : 7814034688 (3726.02 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4b8de95b:90a2aed7:c0ae092b:a056dd95

  Reshape pos'n : 8192 (8.00 MiB 8.39 MB)
  Delta Devices : 1 (9->10)

    Update Time : Tue May  7 13:12:19 2013
       Checksum : a4f483fd - correct
         Events : 298792

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 9
   Array State : AAAAAAAAAA ('A' == active, '.' == missing)

So it seems stuck on the first 8 MB. Is it safe to reboot?

This hangs:

  grep . /sys/block/md1/md/*

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

$ uname -r
3.2.0-0.bpo.1-amd64



/Ole
