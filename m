From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] (Re: Questions regarding startup of imsm container)
Date: Wed, 24 Mar 2010 07:49:46 -0700
Message-ID: <e9c3a7c21003240749y2d8cf545r74b2307ae5dcda0@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	 <20100323080419.GA9374@maude.comedia.it>
	 <20100324115749.1ac9d6f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100324115749.1ac9d6f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 5:57 PM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 23 Mar 2010 09:04:19 +0100
> Luca Berra <bluca@comedia.it> wrote:
>
>> On Mon, Mar 22, 2010 at 09:56:01PM -0600, Randy Terbush wrote:
>> >Having a go at building a raid5 array using the new imsm support an=
d
>> >having good luck keeping drives in the array, etc. Nice work. I hav=
e a
>> >few questions though as I am having some trouble figuring out how t=
o
>> >properly start this container.
>> >
>> ># mdadm --version
>> >mdadm - v3.1.2 - 10th March 2010
>> >
>> ># mdadm -Es
>> >ARRAY metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b7f0
>> >ARRAY /dev/md/Volume0 container=3D30223250:76fd248b:50280919:0836b7=
f0
>> >member=3D0 UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c
>> >
>> ># ls -l /dev/md/
>> >total 0
>> >lrwxrwxrwx 1 root root 6 Mar 22 20:54 0 -> ../md0
>> >lrwxrwxrwx 1 root root 8 Mar 22 20:54 127 -> ../md127
>> >lrwxrwxrwx 1 root root 8 Mar 22 20:54 Volume0_0 -> ../md127
>> >
>> >As you can see, the name for the link in /dev/md does not agree wit=
h
>> >the name that the Examine is coming up with.
>> please read mdadm.conf manpage, under the section "HOMEHOST"
>>
>> >Is it better to just forgo the ARRAY statements and go with an AUTO=
 +imsm?
>> >
>> >And last, does the concept of a write-intent bitmap make sense on a=
n
>> >imsm container? If so, I get a segv if trying to run mdadm /dev/mdX
>> >-Gb internal on either device.
>>
>> i don't believe it makes sense at all, surely imsm do not support an
>> internal bitmap (no provisioning for it in the metadata)
>>
>> The attached patch completely disables bitmap support for arrays wit=
h
>> externally managed metadata.
>
> Thanks for the patch. =A0However I would prefer to disable bitmap sup=
port for
> those metadata formats which report that they don't support it.
> Thus the following patch.
>
> Thanks,
> NeilBrown
>
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!st->ss->add_internal_bitmap) {
[..]
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (st->ss->add_internal_bitmap =3D=3D =
NULL) {
[..]
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (!st->ss->locate_bitmap) {

The smallest of nits, or maybe just a clarification.  I believe you
have said in the past that you prefer the readability of
positive-logic if statements where possible.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
