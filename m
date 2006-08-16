From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: remark and RFC
Date: Wed, 16 Aug 2006 11:06:10 +0200 (MET DST)
Message-ID: <200608160906.k7G96A204753@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello - 

I believe the current kernel raid code retries failed reads too
quickly and gives up too soon for operation over a network device.

Over (my) the enbd device, the default mode of operation was
before-times to have the enbd device time out requests after 30s of net
stalemate and maybe even stop and restart the socket if the blockage was
very prolonged, showing the device as invalid for 5s in order to clear
any in-kernel requests that haven't arrived at its own queue. 

That happens, and my interpretation of reports reaching me is that the
current raid code sends retries quickly, which all fail, and the device
gets expelled, which is bad :-(.

BTW, with my old FR1/5 patch, the enbd device could tell the raid layer
when it felt OK again, and the patched raid code would reinsert the
device and catch up on requests marked as missed in the bitmap.

Now, that mode of operation isn't available to enbd since there is no
comm channel to the official raid layer, so all I can do is make the
enbd device block on network timeouts.  But that's totally
unsatisfactory, since real network outages then cause permanent blocks
on anything touching a file system mounted remotely (a la NFS
hard-erroring style).  People don't like that.

And letting the enbd device error temporarily provokes a cascade of
retries from raid which fail and get the enbd device ejected
permanently, also real bad.

So,

1) I would like raid request retries to be done with exponential
   delays, so that we get a chance to overcome network brownouts.

2) I would like some channel of communication to be available
   with raid that devices can use to say that they are
   OK and would they please be reinserted in the array.

The latter is the RFC thing (I presume the former will either not
be objectionable or Neil will say "there's no need since you're wrong
about the way raid does retries anyway").

The way the old FR1/5 code worked was to make available a couple of
ioctls.

When a device got inserted in an array, the raid code told the device
via a special ioctl it assumed the device had that it was now in an
array (this triggers special behaviours, such as deliberately becoming
more error-prone and less blocky, on the assumption that we have got
good comms with raid and can manage our own raid state). Ditto
removal.

When the device felt good (or ill) it notified the raid arrays it
knew it was in via another ioctl (really just hot-add or hot-remove),
and the raid layer would do the appropriate catchup (or start bitmapping
for it).

Can we have something like that in the official code? If so, what?

Peter
