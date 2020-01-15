From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Debian Squeeze raid 1 0
Date: Wed, 15 Jan 2020 00:06:48 +0000
Message-ID: <5E1E5798.60406@youngman.org.uk>
References: <CAC4UdkbjUVSpkBM88HB0UJMqXh+Pd7CRLaya=s81xMGs-9+m_Q@mail.gmail.com>
 <5E1D6C8E.8030607@youngman.org.uk>
 <CAC4UdkbwYvPHgufBPjNTWzcZW0FcGgGrbmFD_k_mc-Z7NVH9Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC4UdkbwYvPHgufBPjNTWzcZW0FcGgGrbmFD_k_mc-Z7NVH9Pw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rickard Svensson <myhex2020@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/01/20 23:11, Rickard Svensson wrote:
> Hi, I'm very grateful for all  help!
> 
> The Debian 6  mdadm version is:
> mdadm - v3.1.4 - 31st August 2010

Mmmmm ... yes using the new mdadm is very much advisable ...
> 
> I have avoided doing much with the server...
> And the server is still running, did not want to stop it...  But I
> should stop it now?

Have you got an esata port? Can you hook up the replacement drive(s) to
it? That sounds a good plan. You could use USB, but that's probably
going to be a LOT slower.

I can understand not wanting to shut the server down.
> 
> Attaches  below a summary in the log, /sde died by the 9th, but came
> back as /sdf  ???
> And the 12th /sdc dies, and the morning after I discover the problem.
> What I've done since then is only.
> * Remont drive as read only
> * Unmounted ext4, to run fsck
> And that's when I realized it might be even worse.
> 
Well, so long as nothing has written to the drives, and you can recover
a copy, then you should be okay ... cross fingers ...
> 
> My idea is to make a ddrescue copy of the problem disks, and then in a
> new Debian 10 with new mdadm, try to start the raid on the new hd
> copy..?

Yup
> 
> Yes, backing up via ddrescue sounds right.
> BTW it is gddrescue?  ddrescue in Debian 10 seems to be a Windows
> rescue program.
> 
Never heard of gddrescue. ddrescue is supposed to be a drop-in
replacement for dd, just that it doesn't error out on read failures and
has a large repertoire of tricks to try and get round errors if it can.

> I'm change to raid 1 now on the server later on, I have two new 10Tb
> drives, so not the same setup.
> But I have a 6 Tb drive, which I intend to use for this rescue.
> 
> A question about the copy. is it possible to copy to a different
> partition, for example copy sdc2 TO (new 6 TB disk) sdx1,  and then
> sde2 TO (same new disk!) sdx2...

Not a problem - raid (and linux in general) doesn't care about where the
data is, it just expects to be given a block device. It'll just slow
things down a bit. Hopefully with multiple heads per drive, not too
much, but I don't know in detail how these things work.

> And mdadm should (with same luck) be able to put it to the same md0 device.
> Or I'm asking, a copy of a partition will be the same, from what mdadm
> is looking for?
> 
Probably /dev/md126. At the end of the day, you shouldn't care. All you
want to do is assemble the array, see what it gives you as the array
device, and mount that. That should give your ext filesystem back. Run a
"no modify" fsck over it, and if it looks pretty clean (there might be a
little bit of corruption) try mounting it ro and looking it over for
problems.

When you move over to your 10TB drives (will that be a straight raid-1?)
look at dm-integrity (warning - it's experimental with raid but seems
solid for raid-1). And look at using named, not numbered, arrays. My
raid 1's are called /dev/root, /dev/home, and /dev/var.

(Fixed number raid arrays are deprecated - it counts down from 126 by
default now.)

Cheers,
Wol
