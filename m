From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: sb->resync_offset value after resync failure
Date: Tue, 7 Feb 2012 11:11:02 +0200
Message-ID: <CAGRgLy7OZxR-VoQj_ayKx_yBXiVBxUr2NKVGxNjq3=FKXDVaQQ@mail.gmail.com>
References: <CAGRgLy44uKSggEsrU4Fx7op7iVjoPPq-doMdYjxnSGDm6krf9A@mail.gmail.com>
	<20120126115132.75d9d8bd@notabene.brown>
	<CAGRgLy6DWGzWCYjTer2DGv5rpU_78_mPvubKAUv1FiQE40HcbA@mail.gmail.com>
	<20120202091919.1d6dce52@notabene.brown>
	<CAGRgLy75f6Q8Gi0NBiMMFmNz5MSWQdiAaMLRFJUYPzFezMM-pw@mail.gmail.com>
	<20120207115511.619f44e7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207115511.619f44e7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

>> >> 2) If there is a spare, it starts rebuilding the spare, and, as a
>> >> result, persists sb->resync_offset=3D=3Dsb->size in the superbloc=
k
>
> I just looked into this and tested it and I don't agree.
> ->resync_offset does not get set to sb->size. =A0It gets set to the v=
alue that
> curr_resync got up to which is correct .. =A0or fairly close, it shou=
ld really
> be curr_resync_completed.
>
> So I don't think there is a big problem there.

In the scenario I mentioned, I clearly end up having
sb->resync_offset=3D=3Dsb->size (and it actually remains this way, unti=
l
spare rebuild completes and "empty-resync" completes). But I am using
2.6.38-8; perhaps in your kernel this does not happen anymore. If
you're interested to investigate this further, I can send you a repro
script.

Thanks for your help!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
