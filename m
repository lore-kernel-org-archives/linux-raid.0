From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Rebuild on hot-plug
Date: Wed, 31 Mar 2010 12:18:15 +1100
Message-ID: <20100331121815.48cbdf4b@notabene.brown>
References: <20100325113543.0e2124c5@notabene.brown>
	<4877c76c1003241947k63ce9959ta0345012b2556392@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003241947k63ce9959ta0345012b2556392@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, linux-raid@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Wed, 24 Mar 2010 19:47:59 -0700
Michael Evans <mjevans1983@gmail.com> wrote:



> I believe that the default action should be to do /nothing/.  That is
> the only safe thing to do.  If an administrative framework is desired
> that seems to fall under a larger project goal which is likely better
> covered by programs more aware of the overall system state.  This
> route also allows for a range of scalability.

I agree that /nothing/ should be the default action for a device with
unrecognised content.
If the content of the device is recognised, it is OK to have a default with
does what the content implies - i.e. build a device into an array.
But maybe that it what you meant.

I think there is useful stuff that can be done entirely inside mdadm but it
is worth thinking about where to draw the line.  I'm not convinced that mdadm
should "know" about partition tables and MBRs.  Possible the task of copying
those is best placed in a script.

Thanks,
NeilBrown
