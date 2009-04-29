From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: array_state_store: 'inactive' versus 'clean' race
Date: Tue, 28 Apr 2009 18:42:10 -0700
Message-ID: <e9c3a7c20904281842l139cefeev4ab9ea576ca59e5a@mail.gmail.com>
References: <1240881843.30002.42.camel@dwillia2-linux.ch.intel.com>
	 <18934.33566.354244.217291@notabene.brown>
	 <49F74560.7030702@intel.com>
	 <18935.43506.654641.312777@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.43506.654641.312777@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Danecki, Jacek" <jacek.danecki@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 28, 2009 at 6:14 PM, Neil Brown <neilb@suse.de> wrote:
> So we need to:
>
> =A0- remove the rd%d links earlier
> =A0- remove the redundancy group earlier
> =A0- disable starting an array by writing 'clean'.
>
> I think I've convinced myself. =A0Have I convinced you?
>

Yes, the simplicity of just turning off 'inactive->clean' transitions
is indeed convincing.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
