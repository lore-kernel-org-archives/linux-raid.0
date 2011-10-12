From: Keith Keller <kkeller-usenet@wombat.san-francisco.ca.us>
Subject: Re: some general md raid questions
Date: Wed, 12 Oct 2011 10:55:04 -0700
Message-ID: <ps0hm8xas5.ln2@goaway.wombat.san-francisco.ca.us>
References: <1318430825.6598.68.camel@hermosa.site>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-10-12, Peter W. Morreale <morreale@sgi.com> wrote:
>
> Assuming I have two or more jbods attached to the machine, how can I
> determine which disks are associated with which paths?  (Yes, sorry, I
> realize this is a general discovery question and not specific to
> raid :-)

Not positive this is what you want, but you can look at the udevinfo
tool:

# udevinfo -q all -n sdc1
P: /block/sdc/sdc1
N: sdc1
S: disk/by-id/scsi-1AMCC_A367495389E5F400123E-part1
S: disk/by-path/pci-0000:01:03.0-scsi-0:0:1:0-part1
E: ID_VENDOR=AMCC
E: ID_MODEL=9550SX-16M_DISK
E: ID_REVISION=3.02
E: ID_SERIAL=1AMCC_A367495389E5F400123E
E: ID_TYPE=disk
E: ID_BUS=scsi
E: ID_PATH=pci-0000:01:03.0-scsi-0:0:1:0

I hope someone else can answer your other questions; I've just started
using mdraid myself.  I have played with the speed_limit parameters, but
haven't noticed a huge difference (likely because they aren't good
disks, not a fault with md).

--keith

-- 
kkeller-usenet@wombat.san-francisco.ca.us
(try just my userid to email me)
AOLSFAQ=http://www.therockgarden.ca/aolsfaq.txt
see X- headers for PGP signature information


