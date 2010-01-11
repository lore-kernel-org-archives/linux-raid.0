From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: raid failure question
Date: Mon, 11 Jan 2010 13:44:14 -0700
Message-ID: <201001111344.14347.tfjellstrom@shaw.ca>
References: <1263232840.8962.193.camel@kije> <70ed7c3e1001111008y76b49b8bve2b636c90efa4a72@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1001111008y76b49b8bve2b636c90efa4a72@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon January 11 2010, Majed B. wrote:
> Voltage spikes, disks heating (monitored by smartd) & sector
> corruption (monitored by smartd) are what I can think of for the time
> being.

Would that actually make it so a hot spare wouldn't get used automatically? 
I thought the point of a hot spare was to take over for a failed disk /no 
matter what/. Doesn't really make much sense is many of the more common 
error cases cause a hot spare to be ignored.

> On Mon, Jan 11, 2010 at 9:00 PM, Tim Bock <jtbock@daylight.com> wrote:
> > Hello,
> >
> > Excluding the obvious multi-disk or bus failures, can anyone describe
> > what type of disk failure a raid cannot detect/recover from?
> >
> > I have had two disk failures over the last three months, and in spite
> > of having a hot spare, manual intervention was required each time to
> > make the raid usable again.  I'm just not sure if I'm not setting
> > something up right, or if there is some other issue.
> >
> > Thanks for any comments or suggestions.
> >
> > Tim
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
