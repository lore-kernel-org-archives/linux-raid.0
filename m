From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Re:
Date: Sat, 29 Nov 2014 15:08:43 +0000
Message-ID: <21625.57723.353195.123512@tree.ty.sabi.co.uk>
References: <CABGuBc=AJZzxR9W7frK_bdhaq24p1evsOBAdB1Otb4M2hbfqWg@mail.gmail.com>
	<20141127074949.7d437769@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141127074949.7d437769@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> I feel as though I must be missing something that I have had
>> no luck finding all morning.

Probably yes, ad the underlying insight is not explicitly
documented, it is left to the the reader of 'man mdadm.conf':

  "spare-group=3D The value is a textual name for a group of
    arrays. All arrays with the same spare-group name are
    considered to be part of the same group.
    The significance of a group of arrays is that mdadm will,
    when monitoring the arrays, move a spare drive from one
    array in a group to another array in that group if the first
    array had a failed or missing drive but no spare."

>> When setting up arrays with spares in a spare-group, I'm
>> having no luck finding a way to get that information from
>> mdadm or mdstat. This becomes an issue when trying to write
>> out configs and the like,

> mdadm.conf is the primary location for spare-group
> information.  When "mdadm --monitor" is run, it reads that
> file and uses that information.

A more detailed explanations is that MD RAID is divided in two
or arguably three components:

* MD kernel drivers: they *run* RAID sets, but not things like
  *creating* them or *maintaining* them. The MD kernel drivers
  only look at the MD member superblocks and do not look at
  'mdadm.conf' or act of their own initiative in changing RAID
  set membership, only the status of existing members listed in
  the superblocks.

* User space command 'mdadm': this creates MD RAID sets by
  writing "superblocks" that are recognized by the MD kernel
  drivers, and can maintain them when the user does explicit
  commands like '--add' or '--remove'. Options not provided on
  the command line are taken from 'mdadm.conf'.

* User space daemon 'mdadm --monitor': this automatically issues
  *some* 'mdadm' commands, based on the content of 'mdadm.conf'.

>> or simply trying to get a feel for how arrays are setup on a
>> system.

Specifically spare groups are not something that the MD kernel
drivers have any direct role in; the concept of "spare-group" is
only relevant to the 'mdadm --monitor' daemon.

Therefore as the reply above implies one cannot look at the
state of MD arrays as known to the kernel and figure out which
spares and MD arrays are in which spare group, it is something
that is handled entirely in user-space.

In recent version of MD RAID things get an additional dimension
of =ABhow arrays are setup=BB in user-space as 'udev' too can be
configured to do things to MD RAID sets, which are described in
the 'POLICY' and related lines of 'mdadm.conf', and these too
are not recoverable from the information given by the MD kernel
drivers.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
