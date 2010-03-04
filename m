From: Neil Brown <neilb@suse.de>
Subject: Re: I am an idiot. (power failure during chunk resize, no backup
 file)
Date: Fri, 5 Mar 2010 07:45:07 +1100
Message-ID: <20100305074507.41aa5e9e@notabene.brown>
References: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
	<4B8FA12E.9000606@anonymous.org.uk>
	<68c4f7e31003040422u60b75b89id2042a34643424fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c4f7e31003040422u60b75b89id2042a34643424fa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Boag-Munroe <boagenator@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 4 Mar 2010 12:22:53 +0000
Alex Boag-Munroe <boagenator@gmail.com> wrote:

> mdadm is version 3.1.1.  New developments.  I found a post on the
> internet where Neil recommended to someone to recreate the array
> without erasing it.  Which I have done, mdadm starts the array and
> mdadm -D shows that almost a terabyte of space is in use.
> 
> However, mdadm -D also shows a chunk size of 512k, which is neither
> the 64k original chunk nor the 512k I asked for.
> 

You didn't did you?
Oh no, you did!  Two idiotic things.....

Think about what you just did.

You have an array were part has one chunk size and part has another chunk
size.  The only way you can get the data out is to know where in the array
the chunk size changes and tell the kernel that fact.
And what have you just done?  You told mdadm to --create a new array
replacing the metadata so the record of the most important piece of
information: the point where the chunk size changed - just got erased.

If you happen to have an 'mdadm -E' output of the device from before you
re-created the array that might be useful.  If you don't, it will be very
hard to make this work.

What you need to do is:
 - get that information
 - assemble the array without allowing reshape to restart.  You can
   probably do this by writing an appropriate set of things to files
   in /sys - it would have been much easier without the --create
 - mount the filesystem read-only
 - copy out the backup file
 - unmount, unassemble
 - re-assemble with the backup file and let the reshape complete

The last step is possibly the hardest as it really requires writing new
metadata to exactly match the metadata that you erased, and that is not
easy to do - it will require some hacking in C.

If you have the option of copying the whole array elsewhere, then that would
be easiest.
  - find out where chunk size changes
  - assemble array read-only via writes to sysfs
  - copy all the data out
  - mount filesystem, find backup file, apply backup over copied data
  - mount newly copied file system and be sure all is OK
  - make brand new array on original disks.

I can talk you though assembling the array via sysfs if you get to that part.

NeilBrown
