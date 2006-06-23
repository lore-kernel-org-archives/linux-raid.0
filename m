From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Ok to go ahead with this setup?
Date: Fri, 23 Jun 2006 02:45:16 -0400 (EDT)
Message-ID: <Pine.GSO.4.33.0606230232160.2322-100000@sweetums.bluetronic.net>
References: <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Jun 2006, Molle Bestefich wrote:
>I'd watch out regarding the Western Digital disks, apparently they
>have a bad habit of turning themselves off when used in RAID mode, for
>some reason:
>http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/1980/

Where "for some reason" == HEAT.  I've seen Maxtor, Seagate, AND Western
Digital drives all shutdown when they get too hot -- so hot you cannot
touch them.  I know this all too well because Dell is stupid or lazy
to design their cases with proper ventilation over the drives; one drive
simply gets hot, two drives get hot enough to discolor their plastic
drive sleds.

Unless you're talking about little laptop drives, hard drives need active
cooling.  A few CFM is usually enough.  A LOT of people underestimate
the cooling needs of their drives. (and sadly that includes far too many
manufacturers of IDE/SATA drive cages.)

--Ricky


