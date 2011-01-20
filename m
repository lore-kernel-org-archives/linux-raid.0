From: NeilBrown <neilb@suse.de>
Subject: Re: Moving existing RAID5 disks to an alternate server
Date: Thu, 20 Jan 2011 15:48:04 +1100
Message-ID: <20110120154804.3a4695f4@notabene.brown>
References: <AANLkTim4xsHXxBERJf0qucYgAizmzB8__66RR3XnT081@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim4xsHXxBERJf0qucYgAizmzB8__66RR3XnT081@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Powell <powellj@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 19:05:52 -0800 John Powell <powellj@gmail.com> wrote:

> So practically speaking I don't have hardly any experience managing
> RAID volumes. I have used some LSI web bios's to create RAID volumes
> of various forms for functional dev/test and am familiar enough with
> the terminology and implementation but when left with the choice of
> building my own home NAS or buying some proprietary piece of hardware
> pre-configured I chose the later in the interest of time and money.
> Perhaps I made a poor choice there as my proprietary hardware died and
> has left me with a seemingly intact RAID 5 volume spanned over 4 500GB
> PATA disks. Seeing as how the hardware is bricked I am going to
> attempt to pull out those disks and configure a RAID5 volume on a
> custom built machine, (something I constructed over 5 years ago.. it
> still as PATA interfaces :D ). The goal here is to copy the contents
> of this volume to an alternate server that I will be using for backups
> with some more updated hardware.
> 
> Anyhow, the point of my post: Is it really as simple as it sounds? Use
> mdadm to recreate the RAID5 volume and away I go? Are there any
> details that one can offer that I may need to be aware of or is simply
> reading the man pages and various HOWTO's out on the net enough to get
> started? Obviously I am taking this slow as the data on the disks is
> important to me.
> 

"slowly" is good.  You could easily make a mess.  But with suitable care you
will probably be able to get access to all of your data.

The issues are:
 1/ you need to know the correct order of the devices.  They might be in the
 "obvious" order, though if you have ever had a device fail and had to
 replace it, they might not.

 2/ you need to know the 'chunk size' and 'layout'.  It is possible to
 discover these by trial and error, but much easier if you can know for
 certain somehow.

 3/ you need to know which parts of the devices container data and which
 parts contain metadata.  Typically the metadata is at the end and the data
 is at the start of the device.  This is certainly easiest to work with and
 is most likely, but safest not to assume.


If you can answer all those questions with certainty it is quite easy to get
your data back.

As a first step I would see if the metadata is recognised by mdadm or dmraid.
e.g.
   mdadm --examine /dev/sdXXX
or
   dmraid --raid-devices /dev/sdXXX

If you get something informative, report that and we'll go from there.  Don't
assume that just because either of them recognise the format, that they can
work.

If not you will need to try something like:

  mdadm -C /dev/md0 -e 1.0 -l5 -n4 --chunk=128 --layout=ra \
  --assume-clean /dev/sdXX /dev/sdYY ....

and then examine the data on /dev/md0.  If it doesn't look perfect, change
the chunk size, the layout, or the order of the devices until you find
something that works.

Note that this over-writes about 8K at the end of each device.  This probably
does not container important data, but a paranoid person might take a copy of
the last megabyte from each device first, just to be on the safe side.

Note that if you leave out 'assume-clean' then you might be in trouble ... or
you might not, but I cannot make any promises.

NeilBrown
