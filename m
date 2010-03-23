From: Luca Berra <bluca@comedia.it>
Subject: Re: Minor mdadm fixes
Date: Tue, 23 Mar 2010 21:28:08 +0100
Message-ID: <20100323202807.GA2325@maude.comedia.it>
References: <4BA2DDB2.2040508@redhat.com> <20100319070153.GA12455@maude.comedia.it> <4BA9146A.2050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BA9146A.2050901@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 03:20:10PM -0400, Doug Ledford wrote:
>On 03/19/2010 03:01 AM, Luca Berra wrote:
>> On Thu, Mar 18, 2010 at 10:13:06PM -0400, Doug Ledford wrote:
>>> Second: mdadm-3.1.2-mapfile.patch
>>> Problem: Neil's support for putting the mdadm map file wherever you need
>>> it is nice, but one place in particular needs a special case.
>>> Specifically, mdadm already creates /dev/md if needed to store symlinks,
>>> or in the case of mdmon needing to create pid/sock files (if ALT_RUN is
>> why on earth do you want to set ALT_RUN=/dev/md ?
>
>Because on Fedora /lib/init/rw doesn't exist, and neither does any other
>early rw area other than /dev, and it's too late to create a new one, so
Neither in Mandriva for that matter.

>I need to use someplace in /dev.  However, I agree with Neil that if you
>are hiding things under . names then you are admitting something isn't
>right.  So, I'm perfectly happy putting the map file in /dev/md as I
>think it has a perfect right to exist there.
besides the fact that it is perfectly clear that something is wrong, i
am not vehemently opposing that.

>> it is messy enough as it is, let's keep assuming /dev/md contains only
>> array device files.
>
>I don't know how many arrays you have on your system, but I would hardly
>call /dev/md messy.
I did not mean /dev/md is messy, I meant the code for locating the map
file is messy, and the code for handling the mdmon pid and socket is
messy....

for that matter on my test rig i have quite a few file in there
/dev/md/imsm0
/dev/md/Volume0
/dev/md/Volume0p1
....
/dev/md/Volume1
/dev/md/Volume1p1
...

>> besides that you will discover that the only way to make mdmon work is
>> setting VAR_RUN and ALT_RUN to the same value,
>
>[ citation needed ]

two issues:
1) see the thread on this ml starting with:
[mdadm PATCH 5/9] mdmon: mdmon_pid should return pid from either dir
in practice mdadm looks for the mdmon pid and socket in VAR_RUN, but
until takeover the pid and socket are in ALT_RUN, this means you cannot
do array maintainance until /var is mounted rw.
(been there, done that, had to mount a tmpfs on /var and mount --bind
/dev/.mdadm /var/run/mdadm to fix the array)
Neil refused that patch, but allowed redefinition of VAR_RUN, and i did
not insist.

2) having to keep /var/run mounted during shutdown is a PITA, and iirc
you (redhat) were opposed to having mdmon files in /var/run/mdadm, last
time the issue was discussed here.

>> something we can
>> guarantee to be writable even in the direst situation, and i'd keep
>> /dev/.mdadm
>
>There is no guarantee /dev/.mdadm exists on a clean install, where as I
>have made sure that all possible places that might need /dev/md will
>create it if it doesn't exist.  Hence, the direst of situations is
>handled better with /dev/md than with /dev/.mdadm
yes, in mdmon.c ALT_RUN is created before usage, in mapfile.c it is not,
adding an mkdir there would be useful, independent of what we set
ALT_RUN to.

>>> Fourth: mdadm-3.1.2-mapname.patch
>>> Feature: If we are able to easily select the location of the mapfile via
>>> the use of ALT_RUN at compile time, it makes sense to also be able to
>> this "hunt the mapfile" thing is already ugly as it is, why do we need
>> an ALT_MAPNAME?
>
>Because /dev/md/map is too easy a name to conflict with a legitimate md
>array device name, and that's what it defaults to if you set ALT_RUN to
>/dev/md.
>
>> if there was any value (except for allowing to set
>> ALT_RUN to /dev/md) to having the mapfile named differently, just force
>> it to be called mdadm.map everywere (or incremental.map so the name
>> reflects the need for the file existance)
>
>Except I set it to md-device-map.  Aside from not conflicting with md
>device names, the map file name is mostly irrelevant except to indicate
>to people perusing the directory what the file is for as nothing uses it
>besides mdadm and mdadm will gladly use it with whatever name you call
>it as it both creates and uses the file from the same compile time
>configuration setting.
I know all this, what i meant is:
why do you feel there is a need for ALT_MAPNAME, would not it be easier
to just define a MAPFILE_NAME with a fixed path and avoid the open_map
juggling in mapfile.c, there is no need for that code, since, as you
state: "mdadm both creates and uses the file from the same compile time
configuration setting."

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
