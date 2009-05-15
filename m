From: Neil Brown <neilb@suse.de>
Subject: Re: Spares Missing event in case of spare group?
Date: Fri, 15 May 2009 14:38:21 +1000
Message-ID: <18956.61885.121354.537078@notabene.brown>
References: <49EB4B07.9050208@computer.org>
	<0ad180f4fb306d79e27eb9c822acdbaf.squirrel@neil.brown.name>
	<49ECC6CB.7050107@computer.org>
	<49FA9C4D.8040206@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Ceuleers on Friday May 1
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 1, jan.ceuleers@computer.org wrote:
> Jan Ceuleers wrote:
> > NeilBrown wrote:
> >> Yes.  Remove the "spares=1" from each line.
> >> The sole effect of this text is to tell --monitor to expect a spare, and
> >> to complain if no spare is found.
> > 
> > Many thanks. I hadn't picked that up from the manpage, so here is a 
> > patch for your consideration:
> 
> Reasonable patch?

Yes.  Thanks.  (And sorry for the delay :-)

NeilBrown

> 
> > diff --git a/mdadm.conf.5 b/mdadm.conf.5
> > index 40295be..b67bec4 100644
> > --- a/mdadm.conf.5
> > +++ b/mdadm.conf.5
> > @@ -135,6 +135,7 @@ this is mainly for compatibility with the output of
> >  .TP
> >  .B spares=
> >  The value is a number of spare devices to expect the array to have.
> > +The sole use of this keyword and value is as follows:
> >  .B mdadm \-\-monitor
> >  will report an array if it is found to have fewer than this number of
> >  spares when
> 
> Thanks, Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
