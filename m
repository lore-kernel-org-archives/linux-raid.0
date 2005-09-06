From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: MD or MDADM bug?
Date: Tue, 6 Sep 2005 12:17:55 +0200
Message-ID: <62b0912f05090603173d2c7ad2@mail.gmail.com>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	 <17176.13548.477061.774536@cse.unsw.edu.au>
	 <001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
	 <17176.51414.689631.346198@cse.unsw.edu.au>
	 <003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
	 <17177.7688.922030.788691@cse.unsw.edu.au> <43195D20.1070103@dtbb.net>
	 <17178.37305.857263.952767@cse.unsw.edu.au>
	 <62b0912f05090509457a790e22@mail.gmail.com>
	 <17180.62221.163087.348031@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17180.62221.163087.348031@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday September 5, molle.bestefich@gmail.com wrote:
> > But I definitely like autodetection a lot.
> 
> Have you head the lines by Henry Wadsworth Longfellow:
>    There was a little girl
>    Who had a little curl
>    Right in the middle of her forehead;
>    And when she was good
>    She was very, very good,
>    But when she was bad she was horrid.

:-D.  Point taken.

> > > You run
> > >   mdadm -As --config=partitions --hostid=notabene
> > >
> > > then it scans all partitions for md arrays, looks at those with
> > > 'notabene' as the hostname in the 'name' field, and assembles them,
> >
> > So if you change your hostname, you have to modify your initrd?
> 
> No.  hostid can be a kernel parameter.  Or it can be extracted from
> the hardware somehow (MAC address).

Ah, ok!
So the concept is that only the arrays "belonging" to the box will be
automatically assembled.
That's a relief, thanks for the explanation.


> I have two boxed with raid arrays.  One dies.  I plug the drives
> into the other and reboot it.  It comes up with some bits from one
> machines and some bits from the other.

Hopefully it doesn't mix real bits from two arrays onto the same device.


> > The current implementation in MD needs a brush up in those areas too,
> > doesn't it?
> > Would something like
> >
> > [pseudo]
> >
> > // nFATLOAT: newlyFoundArraysThatLookOkAndThusShouldBeAssembled
> > MdDevice[] nFATLOAT = null;
> > do {
> >     if (nFATLOAT != null) assembleArrays(nFATLOAT);
> >     nFATLOAT = findUnassembledButOkArrays();
> > } while (nFATLOAT.length > 0);
> >
> > [/pseudo]
> >
> > work?
> >
> 
> Should a raid5 be assembled when you have found n-1 devices,
> or do you wait for all n?

Hm, that wasn't the point of the algorithm, the point was to
correctly (and non-infinitely-looping-ly) assemble layered MD
devices automatically.

To answer your question, I'd wait till the relevant bus(s)
has been scanned before assembling n-1 arrays.

(In the context of the above pseudo code, that wait would occur
 in findUnassembledButOkArrays()..)

> If you assemble as soon as you find n-1, what do you
> do when the n'th  turns up?

I'd consider that a hot-add event: if the other disks have not
been modified, just add the new disk as-is, otherwise kick off
the reconstruction logic.


> I've had thoughts about allowing read-only assembly to which drives
> can be added if they are found, but nothing concrete yet.

Sounded real good when I first read it, but now I'm having
difficulties deciding whether I like the idea or not :-).

(If the context of the feature is 'automatic assembly at boot-time',
 then all it would give is a small speed gain when booting.  At the
 expense of modifying a lot of software to be able to cope.. hmm)


> Why is it that people never complain about having to put information
> in /etc/fstab about what to mount, but they cannot cope with having to
> put similar information in /etc/mdadm.conf about what to assemble??

They've gotten a taste of the promised land.
You should've never given them autodetection in the first place :-).


Luca Berra wrote:
> in any case autodetection does not belong in the kernel.
> it is far easier to implement and maintain in userspace.

Yes, you're absolutely right.  Hadn't thought of that.
