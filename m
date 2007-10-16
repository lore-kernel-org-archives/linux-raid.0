From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: direction criterium for synchronisation raid1
Date: Tue, 16 Oct 2007 13:33:27 +0200
Message-ID: <ff27i7$jah$1@ger.gmane.org>
References: <47148439.2020706@mail.informatik.uni-essen.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christina Braun <braun@mail.informatik.uni-essen.de> wrote:
> which is in raid1 the criterion for the direction of synchronisation? In 

The event counter :)

> How can I tell the system which mirrored partition is  now the 
> data-source without
> making the raid1 new or zero the superblock?  Is the  destination in 

Usually you don't need to do this. md manages a per-mirror event counter
which always gets increased when relevant events occur like assembling
or stopping an array, adding or removing mirrors etc.
Due to this, whenever you remove a mirror off an raid1, the event
counter of the remaining mirrors gets increased. When you shut down your
machine, plug a disk off and turn the machine on again, once the raid
gets assembled, the event counter of the remaining mirrors gets
increased.

Thus, as long as you access those devices through md only (and don't
mount the device of one of the mirrors as plain filesystem, for
example), the remaining mirrors will always be newer than removed ones
and thus md knows the sync-direction (when they are equally "old", they
are in sync per definition).

There are some exceptions to this:
1. When you like to use the older mirror as source of synchronization,
you have to take care and better zero the superblock of the newer one
before (make sure your raid device did not get assembled, probably based
on the wrong mirror).
2. When you plug a foreign mirror into the system which - however -
refers to the same raid-device (especially having the same UUID etc.)
as your own mirrors but has a bigger event counter, you have to take
care a lot :) This should usually not happen accidentially, as long as
you avoid to assign UUIDs to new raids manually.

> every case the device
> in mdadm manage after the add ? Can I see the source or destination by a 
> info like mdstat or superblock?

Have a look at mdadm -E. This shows you the superblocks of single
mirrors and within them their respective event counters.


regards
   Mario
-- 
A promise to a woman is just a lie that hasn't happened yet.
                                               -- Mr. Floppy

