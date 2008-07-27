From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: possible bug using async_xor() call in ops_run_post_xor()
Date: Sun, 27 Jul 2008 16:19:23 -0700 (PDT)
Message-ID: <753927.795.qm@web81304.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan,
=A0 You right. async_xor() wait for (tx !=3D NULL).
Thanks,
Marri

----- Original Message ----
=46rom: Dan Williams <dan.j.williams@intel.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Friday, July 25, 2008 12:47:27 PM
Subject: Re: possible bug using async_xor() call in ops_run_post_xor()

On Fri, Jul 25, 2008 at 11:45 AM, tirumalareddy marri
<tirumalareddymarri@yahoo.com> wrote:
> I am looking at async_xor() usage and found that if async_xor() retur=
ns null because of=A0 device->device_prep_dma_xor() <async_xor.c> faile=
d to get slot. This might cause failure of stripe creation . Which woul=
d cause data corruption in RAID-5 at high data rates.
> OR
> Data integrity is guaranteed because ops_complete_write() will not be=
 called in the event of=A0 device->device_prep_dma_xor() failed to get =
slot and returned NULL ?

Hi Marri,

ops_complete_write will be called regardless of whether NULL is
returned.=A0 If async_xor returns NULL it simply indicates to the calle=
r
that the operation was completed synchronously.=A0 In current mainline
async_xor will poll for a descriptor so the driver must take care to
ensure forward progress.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
