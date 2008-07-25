From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: possible bug using async_xor() call in ops_run_post_xor()
Date: Fri, 25 Jul 2008 11:45:21 -0700 (PDT)
Message-ID: <833724.76277.qm@web81303.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

I am looking at async_xor() usage and found that if async_xor() returns=
 null because of=A0 device->device_prep_dma_xor() <async_xor.c> failed =
to get slot. This might cause failure of=A0stripe creation . Which woul=
d cause data=A0corruption in RAID-5 at high data rates.
OR
Data integrity is guaranteed because ops_complete_write() will not be c=
alled in the event=A0of =A0device->device_prep_dma_xor() failed to get =
slot and returned NULL ?=20
Thanks,
Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
