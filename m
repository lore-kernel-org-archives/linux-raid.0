From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Thu, 29 Sep 2011 17:18:45 -0700
Message-ID: <CABE8wwt_3DjPqFg5Gm064Gi5OMFFYjuQ9ToAjS+-TYOX+M2ZCw@mail.gmail.com>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
	<20110926193130.6377f5b9@notabene.brown>
	<4E82203A.60507@yazzy.org>
	<20110928091335.1df35f8e@notabene.brown>
	<4E828B92.40502@hardwarefreak.com>
	<4E82C862.8000705@yazzy.org>
	<4E834758.2090508@hardwarefreak.com>
	<20110929094910.2c44ff8a@notabene.brown>
	<CAA9_cmfYPoZVZhm9f+5W5bbTA+1Utb5K=FnZv_=ni8x0=R=Wbg@mail.gmail.com>
	<20110930090720.57534d81@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110930090720.57534d81@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stan@hardwarefreak.com, lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 29, 2011 at 4:07 PM, NeilBrown <neilb@suse.de> wrote:
>> What if as a starting point we could get a Patchwork queue hosted
>> somewhere so you could at least start formally delegating incoming
>> patches for an apprentice to disposition?
>
> I don't know much about Patchwork ... what sort of value does it add?

It just makes things more transparent.  It allows a submitter to have
a web interface to view the state of a patch: accepted, rejected,
under review.  Allows a maintainer or a group of maintainers to see
the backlog and assign (delegate) patches between them.  It also
automates the collection of Acked-by, Reviewed-by, etc tags.

> But I don't think much of the idea of delegation. =A0I don't see a th=
riving
> developer community full of people who want work delegated to them.

So I only meant "delegate" in the Patchwork parlance to make "who is
merging this md/mdadm patch" clear as the apprentice ramps up.  But
this is probably too much mechanics.

It simply sounds like you want a similar situation like what happened
with git.  I.e. a "Junio" to take over but you'll still be around to
course correct and send patches.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
