From: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Subject: Help - Urgent!!!
Date: Thu, 12 Nov 2009 22:53:01 -0600
Message-ID: <200911122253.01626.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Damn!!!

        I was doing some testing at the behest of Doug, when I made a
critical error which locked up the system and now the main array won't
assemble, at all.  I issued the command

`mdadm -G /dev/md0 -b internal --bitmap-chunk=65535`

        And the system complained it was an invalid chunk-size, so I
tried:

`mdadm -G /dev/md0 -b internal --bitmap-chunk=65536`

        This time there was no error, but the command line just hung
solid.  I tired everything I could to recover, but the system just went
downhill more and more.  Finally I tried a shutdown, but even that would
not work.  I had to hit the big red switch, and now when I rebooted the
system, mdadm will not assemble the array no matter what I try.  I tried


`mdadm --assemble /dev/md0 -f`

`mdadm --assemble /dev/md0 -u xxxxxxxx:xxxxxxxxx:xxxxxx:xxxxxx`

        etc.  It just keeps saying, "No devices found for md0".  When I
issue the --examine switch, the information all looks good for all the
drives, just no RAID.  What do I do, now?
