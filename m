From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Sat, 24 Dec 2016 15:34:14 +0100
Message-ID: <CAOxFTcy1EKPrHNKZSYW+2qhL2jMQC9n0WRgX9H53L2DLOREtKg@mail.gmail.com>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
 <22600.7486.444800.536687@quad.stoffel.home> <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
 <22601.44638.79418.124438@quad.stoffel.home> <CAOxFTcwYujHCHeiJiwUc4aA5RpN_9ocoBGfLS1kfgaz=sKSOSQ@mail.gmail.com>
 <87k2arpmvt.fsf@notabene.neil.brown.name> <CAOxFTcxaC1WOj7HeD5bRaPKV93fQZ6X-mBtHOFcQmPwWfjPxDQ@mail.gmail.com>
 <87d1gip8kk.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1gip8kk.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 11:46 PM, NeilBrown <neilb@suse.com> wrote:
> On Sat, Dec 24 2016, Giuseppe Bilotta wrote:
>>
>> Now I wonder if it it would be possible to combine this approach with
>> something that simply hacked the metadata of each disk to re-establish
>> the correct disk order to make it possible to reassemble this
>> particular array without recreating anything. Are problems such as
>> mine common enough to warrant support for this kind of verified
>> reassembly from assumed-clean disks easier?.
>
> The way I look at this sort of question is to ask "what is the root
> cause?", and then "What is the best response to the consequences of that
> root cause?".
>
> In your case, I would look at the sequence of event that lead to you
> needing to re-create your array, and ask "At which point could md or
> mdadm done something differently?".
>
> If you, or someone, can describe precisely how to reproduce your outcome
> - so that I can reproduce it myself - then I'll happily have a look and
> see at which point something different could have happened.

As I mentioned on the first post, the root of the issue is cheap
hardware plus user error. Basically, all disks in this RAID are hosted
on a JBOD that has a tendency to 'disappear' at times. I've seen this
happen generally when one of the disks acts up (in which case Linux
attempting to reset it leads to a reset of the whole JBOD, which makes
all disks disappear until the device recovers). The JBOD is connected
via USB3, but I had the same issues when using an eSATA connection
with port multiplexer, and from what I've read around it's a known
limitation of SATA (as opposed to professional stuff based on SAS).

When this happens, md ends up removing all devices from the RAID. The
proper way to handle this, I've found, is to unmount the filesystem,
stop the array, and then reassemble it and remount it as soon as the
JBOD is back online. With this approach the RAID recovers in pretty
good shape (aside from the disk that is acting up, possibly). However,
it's a bit bothersome and may take some time to free up all filesystem
usage to allow for the unmounting, sometimes to the point of requiring
a reboot. So the last time this happened I tried something different,
and I made the mistake of trying a re-add of all the disks. This
resulted in the disks being marked as spares because md could not
restore the RAID functionality after having dropped to 0 disks.

I'm not sure this could be handled differently, unless mdraid could be
made to not kick all disks out if the whole JBOD disappears, but
rather wait for it to come back?


-- 
Giuseppe "Oblomov" Bilotta
