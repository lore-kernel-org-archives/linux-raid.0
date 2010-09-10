From: CoolCold <coolthecold@gmail.com>
Subject: Re: 5 drives lost in an inactive 15 drive raid 6 system due to cable
 problem - how to recover?
Date: Fri, 10 Sep 2010 23:39:08 +0400
Message-ID: <AANLkTiknvajTtJuCBO927tGcNLB+4R+pXev68snrU4kr@mail.gmail.com>
References: <4C87C656.2030405@stern.nyu.edu>
	<20100909073530.1e5da34d@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100909073530.1e5da34d@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Norman White <nwhite@stern.nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil can you share that decision making algorithm ?
We have servers with "lucky" aic9410 & LSI 1068E controllers which
hang system sometimes, then drive(s) are dropped.
In simple cases, when one drive has different Events count it's enough
to force assemble, but in other cases when, say 8 drives are dropped
like in Kyler's case (
http://marc.info/?l=3Dlinux-raid&m=3D127534131202696&w=3D2 ) and examin=
e
shows different info for drives from the same array, ie
http://lairds.us/temp/ucmeng_md/20100526/examine_sdj1 ,
http://lairds.us/temp/ucmeng_md/20100526/examine_sda1 . Keeping in
mind that drives can be exported in different order on every boot,
it's not so straightforward to detect "right" options.

I promise to put that knowledge on wiki.

On Thu, Sep 9, 2010 at 1:35 AM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 08 Sep 2010 13:22:30 -0400
> Norman White <nwhite@stern.nyu.edu> wrote:
>
>> We have a 15 drive addonics array with 3 5 port sata multiplexors, o=
ne
>> of the sas cables was knocked out to one of the port multiplexors an=
d now
>> mdadm sees 9 drives , a spare, and 5 failed, removed drives (after
>> fixing the cabling problem).
>>
>> A mdadm -E on each of the drives, see 5 drives (the ones that were
>> uncabled) as seeing the original =A0configuration with 14 drives and=
 a
>> spare, while the other 10 drives report
>> 9 drives, a spare and 5 failed , removed drives.
>>
>> We are very confident that there was no io going on at the time, but=
 are
>> not sure how to proceed.
>>
>> One obvious thing to do is to just do a:
>>
>> mdadm --assemble --force --assume-clean /dev/md0 sd[b,c, ... , p]
>> but we are getting different advice about what force will do in this
>> situation. The last thing we want to do is wipe the array.
>
> What sort of different advice? =A0From whom?
>
> This should either do exactly what you want, or nothing at all. =A0I =
suspect
> the former. =A0To be more confident I would need to see the output of
> =A0 mdadm -E /dev/sd[b-p]
>
> NeilBrown
>
>
>>
>> Another option would be to fiddle with the super blocks with mddump,=
 so
>> that they all see the same 15 drives in the same configuration, and =
then
>> assemble it.
>>
>> Yet another suggestion was to recreate the array configuration and h=
ope
>> that the data wouldn't be touched.
>>
>> And even another suggestion is to create the array with one drive
>> missing (so it is degraded and won't rebuild)
>>
>> Any pointers on how to proceed would be helpful. Restoring 30TB take=
s
>> along time.
>>
>> Best,
>> Norman White
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
