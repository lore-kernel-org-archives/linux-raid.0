From: hansbkk@gmail.com
Subject: Re: Temporarily Disable Array
Date: Thu, 10 Feb 2011 02:08:41 +0700
Message-ID: <AANLkTi=wMnKhZCMan-TnA=RqCMhNrZ52bzXdK8hq7quF@mail.gmail.com>
References: <AANLkTiktOdqq5Y3OWvU5dusDy+t_guEo88jm=DN-HnR8@mail.gmail.com>
	<4E.7A.13137.FEA805D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E.7A.13137.FEA805D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 8, 2011 at 7:14 AM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>> From: hansbkk@gmail.com [mailto:hansbkk@gmail.com]
>> FFR did you do this and did it work?
>
>        I did, but it didn't work as I had planned.  About a year ago,=
 I ran
> across a bug that had caused the homehost field on the arrays to gave=
 a pair


Thanks for the update Leslie.  Assuming your specific issues didn't
arise, is this checklist complete, or did you find you needed to do
something else to prevent auto-assembly?

------------------------------

>> > 1. =A0Edit /etc/mdadm/mdadm.conf and comment out the line specifyi=
ng the
>> > array. =A0Also comment out the line "HOMEHOST <system>"
>> >
>> > 2. =A0Edit /etc/fstab and comment out the line specifying the moun=
t point
>> for
>> > the array.
>> >
>> > 3. =A0Issue the command `update-initramfs -u`
>> >
>> > 4. =A0Reboot the system, making sure the array does not assemble.
>> >
>> > 5. =A0Perform the OS upgrade.
>> >
>> > 6. =A0Edit mdadm.conf and fstab, removing the comment markers plac=
ed in
>> steps
>> > 1 and 2.
>> >
>> > 7. =A0Issue the command `update-initramfs -u`
>> >
>> > 8. =A0Reboot the system, making sure the array assembles and mount=
s.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
