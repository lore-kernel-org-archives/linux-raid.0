From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Thu, 1 Apr 2010 16:46:12 -0700
Message-ID: <y2u4877c76c1004011646i5225499bx3f3217491ef4f029@mail.gmail.com>
References: <4BB49E4D.1090809@maxeaves.co.uk> <4BB4A461.5030704@redhat.com>
	 <4BB4A89F.7030707@maxeaves.co.uk>
	 <20100402074325.3ce34e8f@notabene.brown>
	 <20100401224644.GA2455@lazy.lzy>
	 <1270162736.24051.0.camel@travelmate.workshop>
	 <20100401230437.GA5067@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100401230437.GA5067@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Jools Wills <jools@oxfordinspire.co.uk>, Neil Brown <neilb@suse.de>, max@maxeaves.co.uk, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Thu, Apr 1, 2010 at 4:04 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
>> > but since it is not possible to correct those errors,
>> > there is no point in doing it... :-)
>>
>> Well it can. It can try and rewrite the block based on the data from=
 the
>> other disks, and if the drive needs to, it can remap the bad block.
>
> you might be unaware of the repeated neverending
> discussions about this topic.
>
> It is *possible* to do it, but, as of today, it
> cannot do it.
>
> I mean, there is no functionality, in the RAID-6, to
> detect and correct those errors using the available
> double parity.
>
> Consider that the RAID check returns only how many
> mismatch are present, not where they are, i.e. on
> which disks.
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You are correct in that /silent/ errors cannot be detected, however
drives typically do not verify writes and if for whatever reason a
sector that was written cannot be read back the drive will
/eventually/ return an error.  At this point a re-write is issued
based on the data recovered from the other drives.  Only if that fails
is the drive kicked from the array.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
