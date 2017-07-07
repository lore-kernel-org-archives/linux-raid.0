From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Linear device of two arrays
Date: Sat, 8 Jul 2017 00:20:30 +0200
Message-ID: <20170707222030.GA26535@metamorpher.de>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu>
 <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
 <20170707212036.GA26305@metamorpher.de>
 <20170708025318.216210e7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170708025318.216210e7@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Veljko <veljko3@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jul 08, 2017 at 02:53:18AM +0500, Roman Mamedov wrote:
> however it requires a shrinkable filesystem, and XFS cannot be shrunk.

There's a description of the manual process here:

https://wiki.ubuntuusers.de/Howto/LVM_nachtr%C3%A4glich_einrichten/

(Sorry it's in German)

You have to adapt it to use two extents on another PV instead 
of shrinking the filesystem or growing the existing blockdevice.

It can be done, but yeah it's a bit of voodoo.
Copying is safer.

Regards
Andreas Klauer
