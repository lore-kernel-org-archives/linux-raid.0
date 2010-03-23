From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Questions regarding startup of imsm container
Date: Tue, 23 Mar 2010 14:01:28 -0700
Message-ID: <e9c3a7c21003231401p55d4e392u22b062aaf464b1da@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Terbush <randy@terbush.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 22, 2010 at 8:56 PM, Randy Terbush <randy@terbush.org> wrote:
> Having a go at building a raid5 array using the new imsm support and
> having good luck keeping drives in the array, etc. Nice work. I have a
> few questions though as I am having some trouble figuring out how to
> properly start this container.
>
> # mdadm --version
> mdadm - v3.1.2 - 10th March 2010
>
> # mdadm -Es
> ARRAY metadata=imsm UUID=30223250:76fd248b:50280919:0836b7f0
> ARRAY /dev/md/Volume0 container=30223250:76fd248b:50280919:0836b7f0
> member=0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c
>
> # ls -l /dev/md/
> total 0
> lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
> lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
> lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
>
> As you can see, the name for the link in /dev/md does not agree with
> the name that the Examine is coming up with.

It looks like your array was auto-assembled without the help of a
configuration file (what distribution are you using?).  When there is
no configuration file mdadm will append _<num> to indicate that this
might be a foreign array (i.e. an array from another system).  The
only way the imsm code knows that the array is local is by having an
up to date mdadm.conf file with all your local arrays listed.

If you add the following lines to your configuration file:
ARRAY /dev/md0 UUID=30223250:76fd248b:50280919:0836b7f0
ARRAY /dev/md/Volume0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c

You should get the expected name.  Note that the arrays might be being
assembled by your initramfs environment.  So you may need to re-run
mkinitrd after modifying mdadm.conf.

> Is it better to just forgo the ARRAY statements and go with an AUTO +imsm?

If you don't mind the naming discrepancy then you can keep your current setup.

> And last, does the concept of a write-intent bitmap make sense on an
> imsm container? If so, I get a segv if trying to run mdadm /dev/mdX
> -Gb internal on either device.

That should be disallowed for imsm rather than segfault, I'll take a
look at addressing that.  The current write-intent bitmap
implementation is only compatible with native md-metadata for an
internal bitmap.  However, you should still be able to use an external
bitmap with imsm.  The imsm internal equivalent "dirty-stripe journal"
is still on the to do list.

> Thanks for your help

Thanks for the report,
Dan
