From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 09:31:01 -0700
Message-ID: <f3177b9e0911100831n6e269c25h5cc0cf7f9c1e4f1@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <1257846132.22155.155.camel@localhost>
	 <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
	 <70ed7c3e0911100743y55a1eef5p5705cd9cd1f1aa51@mail.gmail.com>
	 <f3177b9e0911100758n2a663d16hc15a6c90e88346b7@mail.gmail.com>
	 <70ed7c3e0911100801j2880965p7a5d6e03c74248dd@mail.gmail.com>
	 <20091110161527.GB2380@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091110161527.GB2380@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 9:15 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Tue Nov 10, 2009 at 07:01:02PM +0300, Majed B. wrote:
>
>> Which disks can provide 2ms response with a read of 250 MB/s and wri=
te
>> of 170 MB/s other than SSDs?!
>>
>> Are you saying that it doesn't matter whether we use Linux or Window=
s
>> with SSDs because the limitation is coming from the disk's controlle=
r
>> itself?
>>
> Not exactly - without TRIM support, the drive performance will degrad=
e
> over time.

Not true.  First, it never effects read performance (you didn't
qualify).  Given that SSD's have a management layer that rotating
media doesn't, it is a very complex issue, and dependent on the SSD
management layer's algorithms.  For many of these algorithms, most
typical write usage performance is completely unaffected.  The biggest
performance effect is seen in benchmarks that were designed w/
rotating media in mind that makes assumptions that don't apply to real
applications, but given rotating media's simplicity were justifiable.
Those assumptions are no longer justifiable given SSD's management
layer; benchmarks must be re-coded to exhibit more application-like
behavior.

> =A0Windows 7 has TRIM implemented for deletes (and formats),
> which prevents this degradation. =A0Initial performance will be the s=
ame
> on both systems though (as performance is limited by the interface -
> SATA 6G is starting to appear though, which will definitely help).
>
> Currently, AFAIK, none of the Linux filesystems support TRIM.

ext4 supports discard.  I've been using successfully since 2.6.27.
=46AT did too, but it was pulled.

> =A0This is
> largely due to discussions about the implementation - a TRIM call
> requires a full flush of all pending writes (as it's a non-queueable
> call) which results in severe performance issues if done synchronousl=
y
> on deletes.

This only causes performance issues for ill-designed SSD's that put
themselves behind legacy controllers for compatibility reasons.
Conceptually, for SSS, the earlier the TRIM the better (the sooner the
management layer can use that information), no matter the perceived
fragmentation.  The performance issue only arises with the poor
compatibility design, but, given they are the loudest voices in the
Linux community, their design will prevail.

Chris
>
> HTH,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
