From: Neil Brown <neilb@suse.de>
Subject: Re: Future of md multipath
Date: Fri, 6 Mar 2009 16:32:09 +1100
Message-ID: <18864.46425.242906.213929@notabene.brown>
References: <20090303180433.GA27569@lst.de>
	<18863.15828.150450.275712@notabene.brown>
	<20090305130017.GA1696@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from martin f krafft on Thursday March 5
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@debian.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 5, madduck@debian.org wrote:
> also sprach Neil Brown <neilb@suse.de> [2009.03.05.0349 +0100]:
> > I'm in favour of deprecating it.  Whenever I hear of people using it I
> > suggest dm-multipath, but there could people I don't here about.
> > I think the upcoming mdadm-3.0 will need a compile-time option to
> > enable multipath, so people will only get it if they really really
> > want it.
> 
> How do you propose a distro to deal with this? Keep it enabled for
> a certain time (with a deprecation warning?) and then just to close
> the doors on users who still need it?
> 
> How long will you support it after deprecation?
> 
> I understand that dm-multipath is more favourable, but unless
> there's a riskless way to convert mdadm multipath into dm-multipath
> on old systems, I don't think we have the option of deprecating it,
> unless deprecation lasts for several years.

Always the practical one, aren't you :-)

I wonder how hard it would be to get mdadm to assemble a multipath
using the 'dm' code rather than the 'md' code....
Or to get the md layer in the kernel to hook in to the dm multipath
implementation.

I think it is probably worth putting in a printk now to say "You
should probably be using dm-multipath".  But we probably do need to
leave the code there for a while longer..

NeilBrown
