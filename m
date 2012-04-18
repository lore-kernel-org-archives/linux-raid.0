From: "." <desire@gmail.com>
Subject: Re: software raid and ERC
Date: Wed, 18 Apr 2012 11:12:57 +0800
Message-ID: <CAAevFRRh2YiQOe1cbEFc+wY8UnBCEMAvrLdBsQLzfWt-6URpXA@mail.gmail.com>
References: <CAAevFRRuGc6x4hJax-kM8ncW9=873aRnjN-WWkoheYD7r6jimA@mail.gmail.com>
 <CAAevFRQw97xTgpct9ML_SWAyw-Zc=9fuioigVBpg7HpZ89kQxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAevFRQw97xTgpct9ML_SWAyw-Zc=9fuioigVBpg7HpZ89kQxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to the couple of folks who have replied on/off-list, but it
didn't precisely answer what causes drives performing deep recovery to
be kicked out (and I haven't found suitable answers in the list
archives either):

The ERC wiki [1] and Red Hat Storage Administration Guide [2] clearly
describe this behavior of the SCSI layer : a drive performing deep
recovery would miss a scsi command timeout, which would cause the SCSI
layer to attempt to abort the command and reset the device/bus/host.
If these error handlers fail, the drive is set offline (which I
presume is what kicks the drive out).

The SCSI command timeout can be tuned at
/sys/block/.../device/timeout, and defaults to 30 seconds.  Perhaps
raising this timeout to a large value would also prevent deep recovery
cycles from causing the _SCSI layer_ to set the drive offline.  True
or False?

Apart from the behaviour of the SCSI layer, does the linux software
raid layer have any concept of timeouts that would cause a drive to be
kicked when performing a deep recovery cycle?  A storagereview forum
thread [3] claims that the linux software raid layer does not have a
concept of timeouts and does not care about ERC.  In a web article [4]
the major NAS manufacturers that use software raid seem to agree with
this stance.

On the other hand, how I interpret a previous post from Stefan [5] is
that the linux raid layer does have its own timeout mechanism that
will kick a non-responding drive.

> Without ERC-timeout, the drive tries to correct the error on
> its own (not reacting on any requests), mdraid assumes an error after a
> while and tries to rewrite the "missing" sector (assembled from the
> other disks).  But the drive will still not react to the write request
> as it is still doing its internal recovery procedure.  Now mdraid
> assumes the disk to be bad and kicks it.

Since I can't read code, I'm hoping that this list where software raid
development takes place would be able to clear up whether

a.  Do delays caused by deep recovery cycles actually have any direct
impact on the linux software raid layer, or does it simply issue a
command to the underlying storage/scsi subsystem and block until there
is a response?

b.  If there is no direct impact to the software raid layer, and the
impact is indirectly caused by the drive being set offline when a SCSI
command timeout and error handling routine fails...  would increasing
the scsi command timeout help to mitigate ERC delays?

Your comments and insights are much appreciated.

[1] http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery#Software_Raid

[2] http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html-single/Storage_Administration_Guide/index.html#task_controlling-scsi-command-timer-onlining-devices

[3] http://forums.storagereview.com/index.php/topic/29208-how-to-use-desktop-drives-in-raid-without-tlererccctl/page__view__findpost__p__266337

[4] http://www.smallnetbuilder.com/nas/nas-features/31202-should-you-use-tler-drives-in-your-raid-nas

[5] http://marc.info/?l=linux-raid&m=128640221813394&w=2

[snipped the previous lengthy email]
