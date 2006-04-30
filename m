From: Neil Brown <neilb@suse.de>
Subject: Re: RFC: PATCH
Date: Sun, 30 Apr 2006 14:20:22 +1000
Message-ID: <17492.15110.997827.911138@cse.unsw.edu.au>
References: <3e1c369e0604290147t27cfc031n2fc25ceb49da2b99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dennis Stout on Saturday April 29
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Stout <stoutman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 29, stoutman@gmail.com wrote:
> It was annoying to me to have to edit the output of mdadm -Escb
> partitions in order to get a working mdadm.conf file so I wrote a
> patch that allows the output of the above command to be used directly
> as a config file.
> 
> Probably still wise to poke the config file before using it in a
> production system, but that goes for anything.
> 
> Dennis Stout
> 
> Enclosed: mdadm-2.1-Examine_output_fix-1.patch (637bytes)

This is definitely not what you want to do.

(for those who haven't read the patch, it replaces the
          device=/dev/a,/dev/b,...
line that "mdadm -Ebv" shows with
DEVICE /dev/a /dev/b ...
)

The DEVICE line should *NOT* list explicit devices to be checked.  It
should either be
   DEVICE partitions
meaning to check all devices mentioned in /proc/partitions, or it
should be some wildcard list that encompasses everything that could
possibly be relevant. e.g.
   DEVICE /dev/hd*
if you know all your devices are IDE devices and you don't want to
scan SCSI devices for some reason.

This is because in most cases devices names can change after a
reconfiguration and/or reboot and so depending on fixed device names
isn't safe.

The change I have been considering that would "make the output of
-Esb more useful" would be to assume a default DEVICE line of
   DEVICE partitions
if none were given.  This is probably safe and useful.

NeilBrown
