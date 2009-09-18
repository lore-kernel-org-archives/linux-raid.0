From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 18 Sep 2009 11:17:27 +0300
Message-ID: <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nfoe$n8p$3@ger.gmane.org> <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>
	<1253106813.17888.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1253106813.17888.9.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've re-read this thread and I was wondering if: echo check >
/sys/block/$array/md/sync_action would help me (and possibly Matthias)
in any way.

I have a RAID5 array of 8 disks running degraded on 7. One of the 7
has bad sectors and the one that is not in the array also had bad
sectors.

I zeroed the one out of the array (with dd) and then cloned the one
with bad sectors in the array to it using dd_rescue.

Later, I reassembled the array using the cloned disk instead of the ori=
ginal.

So now, I'm sure I still have inconsistencies, but would doing the
action above force a correction? Also, would that work on a degraded
array?

Thank you.

On Wed, Sep 16, 2009 at 4:13 PM, Matthias Urlichs <matthias@urlichs.de>=
 wrote:
> On Wed, 2009-09-16 at 11:41 +0200, Goswin von Brederlow wrote:
>> Alternatively write a re-map device-mapper target that reserves some
>> space of the disk and remaps bad blocks itself.
>>
> That'd require some place to store the mapping so that the whole thin=
g
> still works after a reboot. Which should probably be on a different
> disk.
>
> I tend to want to move (part of) that problem to userspace; you may w=
ant
> to do more than a simple remapping of a few blocks when that happens
> (e.g. test-reading the surrounding area).
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
