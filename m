From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Tue, 21 Apr 2009 20:15:20 +0200
Message-ID: <20090421181519.GA4114@lazy.lzy>
References: <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090420211332.GA5550@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 11:13:32PM +0200, Luca Berra wrote:
> add --auto=md to the command line
> or put it in the create line in mdadm.conf

Actually I must this did not work quite right
after reboot...

This might be a Fedora 10 issue, so maybe Doug would like
to comment.

After reboot, someone, I guess udev, tries to automagically
start a RAID, so it assembles /dev/md_d127 with one of the
two components of /dev/md/boot (randomly, it seems).
Later, when /dev/md/boot is assembled, one drive is "busy",
because it belongs to /dev/md_d127, and the array is put
together degraded, i.e. with the other disk only.

This happens also after re-creating the initrd.

So, it seems there is still work to do...

Thanks,

bye,

-- 

piergiorgio
