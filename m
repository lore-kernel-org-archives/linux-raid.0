From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 23:24:44 +0200
Message-ID: <20090420212444.GA5193@lazy.lzy>
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

Thanks, that did the trick!

Interesting, it seems now I have 3 devices
for that raid.
One is /dev/md127, one is /dev/md/boot, with
same (major, minor) as md127, and there is a
third one, /dev/md_boot, which is a symbolic
link to /dev/md/boot.

/proc/mdstat reports /dev/md127

bye,

-- 

piergiorgio
