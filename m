From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 1 Sep 2011 22:32:30 -0700
Message-ID: <CAEUYfyP6vdicUKmKs1=go=E0LrErDZ7XacvhLZD8oacYm7rFPQ@mail.gmail.com>
References: <4E5FA4B5.6010407@macroscoop.nl>
	<4E5FAEF3.60501@macroscoop.nl>
	<4E5FB350.3040905@redhat.com>
	<4E5FC495.7070909@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FC495.7070909@macroscoop.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 1, 2011 at 10:44 AM, Pim Zandbergen
<P.Zandbergen@macroscoop.nl> wrote:
> On 09/01/2011 06:31 PM, Doug Ledford wrote:
>>
>> Why is your raid metadata using this old version? =A0mdadm-3.2.2-6.f=
c15 will
>> not create this version of raid array by default. =A0There is a reas=
on we have
>> updated to a new superblock.
>
> As you may have seen, the array was created in 2006, and has gone thr=
ough
> several similar grow procedures.
>
>> Does this problem still occur if you use a newer superblock format (=
one of
>> the version 1.x versions)?
>
> I suppose not. But that would destroy the "evidence" of a possible bu=
g.
> For me, it's too late, but finding it could help others to prevent th=
is
> situation.
> If there's anything I could do to help find it, now is the time.
>
> If the people on this list know enough, I will proceed.
>
> Thanks,
> Pim

I ran into this exact problem some weeks ago. I don't recall any error
or warning messages about growing the array to use 3TB partitions and
Neil acknowledge that this was a bug. He also gave instructions on how
to recover from this situation and re-start the array using 1.0
metadata.

Here is Neil's comment from that thread:

--------------------------------------------------------------------
Oopps.  That array is using 0.90 metadata which can only handle up to 2=
TB
devices.  The 'resize' code should catch that you are asking the imposs=
ible,
but it doesn't it seems.

You need to simply recreate the array as 1.0.
i.e.
 mdadm -S /dev/md5
 mdadm -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean

Then all should be happiness.
>
--------------------------------------------------------------------
Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
