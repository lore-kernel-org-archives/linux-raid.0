From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Bit-Rot
Date: Fri, 17 Mar 2017 17:59:36 +0100
Message-ID: <CAJH6TXhzBxB_mXWk5dkJziffQzGmdfY9nRUm63Jxi39SB2Vfiw@mail.gmail.com>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
 <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk> <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
 <alpine.DEB.2.02.1703050913530.30226@uplift.swm.pp.se> <20170306115648.GG7497@reaktio.net>
 <BD49CADF-6076-44CF-8291-DFE74EA2C6A7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BD49CADF-6076-44CF-8291-DFE74EA2C6A7@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>, Mikael Abrahamsson <swmike@swm.pp.se>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-03-17 16:37 GMT+01:00 Brassow Jonathan <jbrassow@redhat.com>:
> There is a device-mapper target that is designed to do precisely this - d=
m-integrity (see dm-devel mailing list).  It currently being developed as p=
art of an authenticated encryption project, but could be used for this too.=
  Note that there is a performance penalty that comes from emulating this.

Probably something similar could be obtained by checking, during a
scrub, the majority of responses from all replica

A sort of quorum
If you have a 3 way mirror, and 2 disks reply with "1" and another
reply with "0", the disk with "0" has triggered a bit rot

Is mdadm able to make this decision?  In a 2 way mirror would be
impossible, as you can't know which disk has the correct data, but in
a 3 way mirrors you have a majority.

Probably the same could be done in RAID-6, where you have 2 parity to evalu=
ate.
