From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 10:36:09 +0200
Message-ID: <20090418083609.GA4436@lazy.lzy>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090418075436.GA2124@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 09:54:38AM +0200, Luca Berra wrote:
> because people might want control over what is happening.
> otherwise we'll might as well be running windows

There is a difference between having to run it
*always* manually, or having the choice to do
one way (manually) or the other (automantically).

Control is not about manuality, control is about
having the possibility to do what is considered
most convenient.

So, the point is not having it automatic, but
having the choice between automatic or manual,
or both.

> on hotplug udev already tries to assemble raid arrays, this is the topic
> of the discussion, how to make it just work on your desktop/laptop pc,
> and how to make it not break the carefully tuned setup on my server,
> where i will probably never connect usb/esata array.

Well, so we are on the same frequency!

>> The problem is that when something is changed in the array,
>> the file needs to be recreated.
> no, unless you misconfigure mdadm.conf

I did not! :-)

>> For example, this happened to me, after growing the array it
>> was not possibile anymore to restart it without rerunning
>> the "--examin --scan" thing.
> probably because you left some component device name in the mdadm.conf
> file, don't.

The cause is "num-devices", which is set by the
"--examine --scan" or "--detail --scan".
If I grow the array, this changes, and the config
file needs an update.
Of course, the "num-devices" could be removed, but
it is more manual work, which could lead to errors.

>> It seems to me that the usage of mdadm.conf is a bit
>> fragile and looping.
>> To start the array I need mdadm.conf, to create it I
> not really
>> need the array... (maybe alread started).
> i dont see the problem

The problem is that the safer information to assemble
the array is (or should be) the UUID.
Since this is not something easy to remember, it is
necessary to find it out.
The information could be retrieved from the devices
composing it, of course.
I find a bit "silly" to have to check the components
manually in order to configure the file needed to
start the array.

Of course, for a fully static environment, this is
not a big issue. Once done, is done.
For a more "changing" situation, this could be
quite annoying and error prone.
I already had "booting" issue, because I forgot
to *update* the file.

In other words, it would be nice to have some more
automatic method to handle this configuration file.
This should *not* replace the manual operation, it
should just be an add on to it.

Of course, an "udev" solution would be also good,
so I'm not proposing anything different from what
is discussed here.
As I wrote, these are only my two cents or less.

bye,

-- 

piergiorgio
