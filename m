From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Linux: Why software RAID?
Date: Sat, 26 Aug 2006 13:55:36 -0700
Message-ID: <e9c3a7c20608261355k41692c64w9165a22a9b7fab29@mail.gmail.com>
References: <44ED1E41.40606@garzik.org> <44ED3723.3090308@nortel.com>
	 <44ED3851.7040202@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750876AbWHZUzo@vger.kernel.org>
In-Reply-To: <44ED3851.7040202@zytor.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Friesen <cfriesen@nortel.com>, Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

On 8/23/06, H. Peter Anvin <hpa@zytor.com> wrote:
> Chris Friesen wrote:
> > Jeff Garzik wrote:
> >
> >> But anyway, to help answer the question of hardware vs. software RAID,
> >> I wrote up a page:
> >>
> >>     http://linux.yyz.us/why-software-raid.html
> >
> > Just curious...with these guys
> > (http://www.bigfootnetworks.com/KillerOverview.aspx) putting linux on a
> > PCI NIC to allow them to bypass Windows' network stack, has anyone ever
> > considered doing "hardware" raid by using an embedded cpu running linux
> > software RAID, with battery-backed memory?
> >
> > It would theoretically allow you to remain feature-compatible by
> > downloading new kernels to your RAID card.
> >
>
> Yes.  In fact, I have been told by several RAID chip vendors that their
> customers are *strongly* demanding that their chips be able to run Linux
>   md (and still use whatever hardware offload features.)
>
> So it's happening.
Speaking of md with hardware offload features:

http://prdownloads.sourceforge.net/xscaleiop/ols_paper_2006.pdf?download

>         -hpa

Dan
