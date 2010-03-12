From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Re: Resize RAID-0?
Date: Fri, 12 Mar 2010 09:03:01 -0800
Message-ID: <23986fd91003120903s77c36c37lb3f3f770c9457091@mail.gmail.com>
References: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
	 <73e903671003120336m36718a31m1c4ce760c42dbc75@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671003120336m36718a31m1c4ce760c42dbc75@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46irst, thanks to everyone for the helpful responses.

On Fri, Mar 12, 2010 at 3:36 AM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
>
> I agree with others on the list - I believe that LVM will perform wel=
l
> as a flexible stripe wrangler on top of mdadm arrays. For instance
> some LVM striping over mdadm parity-based stuff underneath.

I made a typo in my original post, so let me clarify.  In my
configuration, I have a pair of dual-channel FC HBA cards.  I
currently have three hardware RAID-5 chassis connected to three of the
HBA channels, and I am using Linux md to perform RAID-0 striping
across the channels.  This gives me very high performance -- 800
MiB/sec sustained reads and writes, for hundreds of gigabytes, using
XFS -- at very modest CPU utiliziation.

What I want is to connect a fourth, identical hardware RAID chassis to
the fourth HBA channel and then re-stripe the md RAID-0 across all
four units.  I now understand that this is not currently supported.

> Do you want to add a whole new stripe device, so changing the
> coarse-scale layout, or grow the underlying data containers?

New stripe device.

> As you are running striped, I assume that the data is either
> perishable or backed up.

My data is all reproducible.  (The system spends its time processing
large volumes of data that originated somewhere else.)  We are using
underlying RAID-5 chassis to improve MTBF, not to prevent data loss.

> I'd suggest you look into moving to LVM.

Thanks to Michael Evans and to you for this suggestion; I will investig=
ate LVM.

Thanks once again to everyone who responded.  The world of Linux RAID
may be "gas-lit and magical", but in many ways the support is superior
to any commercial product I have seen.

 - Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
