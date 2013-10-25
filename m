From: Michael Tokarev <mjt@tls.msk.ru>
Subject: changing parameters of a running array?
Date: Fri, 25 Oct 2013 11:39:32 +0400
Message-ID: <526A2034.2050103@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello.

Is there a way to change some parameters - like preferred minor,
array name, homehost, guuid and the like - of a _running_ array?
I understand these can be changed using --assemble --update=foo,
but how about, say, root array which is being assembled from
within an initrd with limited functionality?

What I'm trying to achieve is to make a clone of a (remote)
running system, in order to upgrade hdds.  For this, a new
set of drives are inserted, new set of filesystems is created,
current filesystems are copied to new hdds and on the next
reboot the system should boot from the new hdds.  But since
I can't create arrays with the same names/minors as currently
running ones, and I want to preserve the naming scheme, I
need to ensure the new arrays will be named correctly after
the reboot.  But since the system is remote, this is a bit
difficult to achieve for the root device.

And similarly, I can't --update a NON-running array without
--assemble, so I can't fix the names before reboot while the
old arrays are still running.

Maybe the easiest way is to write a small (perl) program
which will read the superblock of a non-running array, update
it and write it back.  This at least will allow me to perform
tasks before reboot.  But this way it becomes risky - if the
first reboot will happen with the old drives still in place,
havoc might happen, since more than one array will have the
same name...

So a better route will be to create new arrays with temp
names, reboot, change names on the newly running system,
and remove old arrays.  The question is how to change
some params on a running system.

Thanks,

/mjt
