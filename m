From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 20:17:36 +0200
Message-ID: <20090420181736.GB4236@lazy.lzy>
References: <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18924.3824.677493.129885@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 03:58:08PM +1000, Neil Brown wrote:
[...]
> If you use 1.x metadata (e.g. 1.0), then this works nicely.
> 
>  mdadm --create /dev/md/foo --metadata 1.0 --level .....
> 
> This will store the name 'foo' in the metadata and when you assemble
> the array, it will be called /dev/md/foo.
> This will be a symlink to /dev/md125 or something like that, but you
> don't need to care.

Does this really work with mdadm 2.6.7.1?

Because I have this from "--examine --scan"

ARRAY /dev/md/boot level=raid1 metadata=1.0 num-devices=2 UUID=edb4254d:4274fac1:dd6cad61:a8e3c347 name=boot

Of course, /dev/mdadm.conf has the same entry.

But:

$> mdadm -A --scan
mdadm: /dev/md/boot does not exist and is not a 'standard' name so it cannot be created

The array was *not* created as you suggested,
but it has metadata 1.0 and a name.
Which name is also returned by --examine --scan
as array device name.

Thanks,

bye,

-- 

piergiorgio
