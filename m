From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PANIC] : kernel BUG at drivers/md/raid5.c:2756!
Date: Fri, 4 Nov 2011 11:25:41 -0700
Message-ID: <CAE0An6eSxFBYbHj7M=k4YDJdUv3oP8Y3_Sc3BB7K2RKix0W-yw@mail.gmail.com>
References: <CAE0An6cvpqD8oPiHr2CAb753hC=47BYErOwAxaXoeHOYPaVznA@mail.gmail.com>
 <20111101163931.4d85e330@notabene.brown> <CAE0An6em5crdkSJOLHSB85fQ95Br5HRmu3pa-E4O10X5y7vr9g@mail.gmail.com>
 <20111101172946.1bf765f4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111101172946.1bf765f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Mon, Oct 31, 2011 at 11:29 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 31 Oct 2011 23:09:04 -0700 Manish Katiyar <mkatiyar@gmail.com=
> wrote:
>
>> > I think you were quite unlucky to hit this and that you will find =
it hard to
>> > reproduce. :-(
>>
>> Well, its always reproducible on my ubuntu when I run that script.
>>
>
> Excellent!! =A0 That means you can reliably see if the patch fixes it=
=2E :-)

Sorry for the late reply. Yes it fixes it for me.



>
> I guess I was thinking of 'real' devices which are slower than XOR. =A0=
You were
> using loop back device on files in /tmp which are presumably always i=
n memory.
> I guess it would be a lot easier to hit in that case.
>
> Thanks,
> NeilBrown
>



--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
