From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID MIA. Again. (Kinda.)
Date: Fri, 5 Mar 2010 19:18:17 -0800
Message-ID: <4877c76c1003051918s552e8446hb2de1ccd31a1cae7@mail.gmail.com>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	 <20100305075016.51e98363@notabene.brown>
	 <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	 <20100305123028.55a34c14@notabene.brown>
	 <a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>
	 <4877c76c1003051205i23998a72xc9df3174c1e7fd17@mail.gmail.com>
	 <20100306073830.40f10294@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100306073830.40f10294@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ken D'Ambrosio <ken@jots.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 5, 2010 at 12:38 PM, Neil Brown <neilb@suse.de> wrote:
> On Fri, 5 Mar 2010 12:05:32 -0800
> Michael Evans <mjevans1983@gmail.com> wrote:
>
>
>> Here's a stab at it. I've never tried to do it like this and haven't
>> glanced at the code so I can't be sure, but this seems to be the mos=
t
>> likely suspect:
>>
>> #ARRAY /dev/md0 level=3Draid5 num-devices=3D4 devices=3Dsda2,sdb2,sd=
d2,sdc2
>>
>> Your commented out version seems to specify this mapping
>> 0,sda2
>> 1,sdb2
>> 2,sdd2
>> 3,sdc2
>>
>
> No it doesn't. =A0The 'devices=3D' lists is an unordered list (as set=
?). =A0It just
> says "only try to include these devices in the array". =A0They still =
have to
> have valid metadata, and it is the content of the metadata the define=
s the
> role of the device in the array.
>
> NeilBrown

Then if mounting the filesystem used to work but now doesn't I have no
idea; based on the currently provided information I saw no other
suspect.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
