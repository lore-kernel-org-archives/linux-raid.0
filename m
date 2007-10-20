From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 18:09:06 +0400
Message-ID: <471A0C02.4030407@msgid.tls.msk.ru>
References: <18200.49267.763509.924873@stoffel.org>	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>	 <18200.53593.687483.120827@stoffel.org> <1192810534.1666.68.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192810534.1666.68.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
[]
> 1.0, 1.1, and 1.2 are the same format, just in different positions on
> the disk.  Of the three, the 1.1 format is the safest to use since it
> won't allow you to accidentally have some sort of metadata between the
> beginning of the disk and the raid superblock (such as an lvm2
> superblock), and hence whenever the raid array isn't up, you won't be
> able to accidentally mount the lvm2 volumes, filesystem, etc.  (In worse
> case situations, I've seen lvm2 find a superblock on one RAID1 array
> member when the RAID1 array was down, the system came up, you used the
> system, the two copies of the raid array were made drastically
> inconsistent, then at the next reboot, the situation that prevented the
> RAID1 from starting was resolved, and it never know it failed to start
> last time, and the two inconsistent members we put back into a clean
> array).  So, deprecating any of these is not really helpful.  And you
> need to keep the old 0.90 format around for back compatibility with
> thousands of existing raid arrays.

Well, I strongly, completely disagree.  You described a real-world
situation, and that's unfortunate, BUT: for at least raid1, there ARE
cases, pretty valid ones, when one NEEDS to mount the filesystem without
bringing up raid.  Raid1 allows that.

/mjt
