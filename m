From: mark delfman <markdelfman@googlemail.com>
Subject: =?windows-1252?Q?MD_performance_options=3A_More_CPU=92s_or_more_Hz=92s=3F?=
Date: Wed, 4 Nov 2009 09:49:33 +0000
Message-ID: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi... I am wondering if anyone can offer some advice on MD performance
related to CPU (speed and or cores).  The basic question (probably too
basic) is =93for more MD performance are you better with more cpu=92s o=
r a
faster single cpu=94.  (in an ideal world we would have lots of very
fast CPUs, but given we never have enough money....).

Is there any grounding to the following logic:

Presuming that a RAID0 will deliver 1.5GBsec and a RAID6 circa
700MBsec, I am guessing there are many complex reasons for the
difference, but one of the more obvious being the need for the CPU to
perform all the necessary R6 overheads.

If we look at a single RAID 6 configuration, then I am guessing if we
increase the speed of the CPU from eg 2.0GHz to 2.8GHz (quad core
xeon) then the RAID6 calculations would be faster?  Would other
overheads also be faster and if so is there any know relationship
between CPU Hz and MD performance (maybe even rough rule of thumb eg
double cpu Hz and increase R6 performance by 20% etc)

If however I start to think of multiple RAID6 configurations maybe via
iSCSI etc... then I wonder if MD would be better served with more CPUs
instead... for example 2 x Quad core 2.0GHz xeons instead of 1 x 2.8.
  This theory is dependent on linux / md effectively parallel
processing the overheads and I have no knowledge in this area... hence
the question.

Any thoughts anyone?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
