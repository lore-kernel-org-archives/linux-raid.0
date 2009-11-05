From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Wed, 4 Nov 2009 23:21:54 -0800
Message-ID: <babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
	<4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Wed, Nov 4, 2009 at 10:17 PM, Michael Evans <mjevans1983@gmail.com> =
wrote:
> =A0 =A0 =A0 -U, --update=3Dhomehost
> =A0 =A0 =A0 --auto-update-homehost

The man pages suggest what to do when assembling/creating the array.

Since I've _got_ arrays already created, that are auto-assembled using
the info IN mdadm.conf, I'm unclear as to how to change/correct the
name=3D field.  Can you clarify?

To my other question, http://man-wiki.net/index.php/8:mdadm#DEVICE_NAME=
S says,

 The standard names for non-partitioned arrays  (the  only  sort  of  m=
d
      array available in 2.4 and earlier) either of

             /dev/mdNN
             /dev/md/NN

      where  NN is a number.  The standard names for partitionable arra=
ys (as
      available from 2.6 onwards) is one of

             /dev/md/dNN
             /dev/md_dNN


Since my arrays are each a single partition (the RAID-10 has LVMs on
the single partition), I guess that the "either of"

             /dev/mdNN
             /dev/md/NN

applies?  And, even if so, why do mdadm --examine & mdadm --detail use
_different_ output formats?

BenDJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
