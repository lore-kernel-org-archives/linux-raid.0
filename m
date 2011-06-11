From: David Brown <david.brown@hesbynett.no>
Subject: Re: Triple-parity raid6
Date: Sat, 11 Jun 2011 20:05:32 +0200
Message-ID: <it0apc$tj0$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org> <20110609114954.243e9e22@notabene.brown> <isqb2o$g0s$1@dough.gmane.org> <20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com> <isslla$o2i$1@dough.gmane.org> <4DF20C18.3030604@christoph-d.de> <ist9n7$khq$1@dough.gmane.org> <20110611101312.GA3528@lazy.lzy> <isvkrg$c79$1@dough.gmane.org> <20110611131801.GA2764@lazy.lzy> <isvvhi$2vf$1@dough.gmane.org> <4DF38424.1010500@gmail.com> <it058n$1ju$1@dough.gmane.org> <4DF3A27E.8080806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF3A27E.8080806@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/11 19:14, Joe Landman wrote:
> A quick note of caution (and someone from Netapp, feel free to speak up).
>
> Netapp has a patent on triple parity raid (c.f.
> http://www.freepatentsonline.com/7640484.html). A quick look over this,
> suggests that the major innovation is the layout and computation which
> they simplified in a particular manner. That is, I don't think their
> patent covers triple parity RAID in general, but does cover their
> implementation, and the diagonal parity with anti-diagonal parity
> (effectively counter propagating or orthogonalized parity).
>
> I am not sure what this means from a coding sense, other than not to use
> their techniques without a license to do so. If Netapp wants to grant
> such a license, this would be good, but I suspect that it wouldn't be
> quite as simple as this.
>
> Just a note so that we don't encounter problems. I think its very
> possible to avoid their IP, as it would somewhat hard to claim ownership
> of the Galois Field math behind RAID calculations. They can (and do)
> claim a particular implementation and algorithm.
>
> [also not trying to open the patent on code wars here, just pointing out
> the current situation ]
>
>

I've read a little about diagonal parities - I can see some advantage in 
their simplicity, but I think that they are a poor choice for raid. 
Raid5+ already suffers from performance issues because you often have to 
read a whole stripe at a time just to change a few blocks - with 
diagonal parity, you'd have to read a whole 2-D set of stripes.


