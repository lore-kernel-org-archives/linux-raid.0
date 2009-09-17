From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID1 assembled broken array
Date: Thu, 17 Sep 2009 20:12:10 +0300
Message-ID: <70ed7c3e0909171012q432f41c4xf2f229a3b3c9e984@mail.gmail.com>
References: <h8ophd$n8p$6@ger.gmane.org> <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
	<65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
	<1253076634.7071.5.camel@kiste> <F52A8F4D-66B0-4F97-B2C9-6FF207817718@redhat.com>
	<1253207377.9662.551.camel@kiste>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253207377.9662.551.camel@kiste>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

0.9 shouldn't be the default if 1.0 or 1.x is better anyway :/

On Thu, Sep 17, 2009 at 8:09 PM, Matthias Urlichs <matthias@urlichs.de>=
 wrote:
> On Thu, 2009-09-17 at 12:44 -0400, Doug Ledford wrote:
>> >> 1.0 also protects from this problem.
>> >
>> > So what's the best way to update a 0.9 superblock to 1.0 format?
>> >
>> > mdadm --assemble --metadata=3D1.0 --update=3Dsummaries ... ?
>>
>> I don't think you can. =C2=A0You just have to create a new array wit=
h the
>> new superblock.
>>
> Hmm. Looks like you're right.
>
> Consider this to be a feature request, then. If 1.0 is more reasonabl=
e
> than 0.9, there should be a "safe" upgrade path.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
