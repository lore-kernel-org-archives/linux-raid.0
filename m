From: Jake Thomas <thomasj10@georgefox.edu>
Subject: Re: Device Unusable At Startup
Date: Sun, 12 Aug 2012 23:45:53 -0700
Message-ID: <CACO8virEMpQU9+AmAAUkPVe=rG9cEJ-uPMLus1v-zX=dPORX3A@mail.gmail.com>
References: <CACO8viqZO9bbdYtZMT3E0oMfWUjAzps1uNq7rBm419eXtt6bCg@mail.gmail.com>
	<20120813102020.172d3a93@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120813102020.172d3a93@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, you wouldn't believe it! I got it working!

Here's what I did:
I got to the Grub menu, hit "e" to temporarily edit my menu entry, and
added "break=premount" to the kernel (linux) line. This causes Linux
to drop you to a recovery shell before the real root is mounted (still
in the initial ramdisk). From there I did "mdadm -R /dev/md127". That
started /dev/md127. Then I entered "exit" to continue the booting
process.

Once fully booted, /dev/md127 no longer was active, even though I got
it active in the pre-mount environment.

From a "regular" (after the real root is mounted) environment, I ran
"sudo mdadm -R /dev/md127". This resulted in:
mdadm: failed to run array /dev/md127: Invalid argument

Then I restarted without doing a break, and "sudo mdadm -R /dev/md127"
resulted with the same error as last time.

Then I re-created the raid device with:
sudo mdadm --stop /dev/md127
(note that the file /dev/md127 still exists, it's just stopped, which
I find interesting.)
sudo mdadm --create /dev/md127 --level=1 --raid-devices=2 /dev/sda2 missing

Then I stopped all devices:

sudo mdadm --stop /dev/md127

(I only had that one device. I probably could have done "sudo mdadm
--stop /dev/md* if I really wanted to wipe them all out, if I had
more.)

Then I renamed mdadm to mdadm.moved:
sudo mv /sbin/mdadm /sbin/mdadm.moved

Then I restarted:
sudo shutdown -r 0

And my ramdisk hybrid raid device was up and running after startup!

One time I didn't stop /dev/md127 and restarted. That corrupted it.

I remade it, and as long as I stopped the device before shutdown, I was good.

Going into the pre-mount environment does not seem to be needed to
make it _NOT_ corrupted, but I wanted to tell the story how it was.


I changed fstab to use the raid device for /usr (specifying by uuid!),
added "/sbin/mdadm.moved --stop /dev/md*" very early in
/etc/rc.shutdown, and added "/sbin/mdadm.moved /dev/disk/by-uuid/[uuid
of my hybrid md device] -a /dev/ram0" to /etc/rc.local.

And now it works!

Yey!!!! Thanks so much Neil Brown and Mr. Green and all y'all!

Super Cheers,
Jake
